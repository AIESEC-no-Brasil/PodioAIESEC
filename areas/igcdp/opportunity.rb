require_relative '../../control/control_database_workspace'
require_relative '../../control/control_database_app'
require_relative 'opportunity_dao'

# This class initializes, configure and take care of the tm module.
# The module is divided in 3 categories:
# * 1. ORS ( 1 x )
# * 2. Local ( Number of entities x )
# * 3. National ( 1 x )
class Opportunity
  # @param spaces [ControlDatabaseWorkspace] List of workspaces registered at the IM General
  # @param apps [ControlDatabaseApp] List of apps registered at the IM General
  def initialize(spaces, apps)
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    abort('Wrong parameter for spaces in ' + self.class.name + '.' + __method__.to_s) unless spaces.is_a?(ControlDatabaseWorkspace)
    abort('Wrong parameter for apps in ' + self.class.name + '.' + __method__.to_s) unless apps.is_a?(ControlDatabaseApp)

    configLocals(spaces, apps)
    configNational(spaces, apps)
    flow
  end

  # Detect and configure every Locals workspaces and Locals apps taht are linkted to tm
  # @todo research how to raise global array local_spaces_ids
  # @todo research how to raise global hash local_apps_ids
  # @param spaces [ControlDatabaseWorkspace] List of workspaces registered at the IM General
  # @param apps [ControlDatabaseApp] List of apps registered at the IM general
  def configLocals(spaces, apps)
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    @local_spaces_ids = {}
    @local_apps_ids1 = {}

    for i in 0...spaces.total_count
      if spaces.type(i) == $enum_type[:local] && spaces.area(i) == $enum_area[:igcdp]
        @local_spaces_ids[spaces.id(i)] = nil
      end
    end

    @entities1 = []
    for j in 0...apps.total_count
      work_id = apps.workspace_id_calculated(j)
      for i in 0...spaces.total_count
        if spaces.id(i) == work_id && !spaces.entity(i).nil? && spaces.area(i) == $enum_area[:igcdp]
          @entities1 << spaces.entity(i)
        end
      end
    end

    @entities1.uniq!
    for entity in @entities1 do
      app1 = nil
      app2 = nil
      app3 = nil
      for j in 0...apps.total_count
        work_id = apps.workspace_id_calculated(j)
        for i in 0...spaces.total_count
          if spaces.id(i) == work_id && !spaces.entity(i).nil? && spaces.entity(i).eql?(entity) && spaces.area(i) == $enum_area[:igcdp]
            case apps.name(j)
              when $enum_iGCDP_apps_name[:open] then app1 = OpportunityDAO.new(apps.id(j))
              when $enum_iGCDP_apps_name[:project] then app2 = OpportunityDAO.new(apps.id(j))
              when $enum_iGCDP_apps_name[:history] then app3 = OpportunityDAO.new(apps.id(j))
            end
          end
          @local_apps_ids1[entity] = {:app1 => app1,
                                      :app2 => app2,
                                      :app3 => app3}

        end
      end
    end

  end

  def configNational(spaces, apps)
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)

    for i in 0...spaces.total_count
      if spaces.type(i) == $enum_type[:national] && spaces.area(i) == $enum_area[:igcdp]
        @national_space_id = spaces.id(i)
        break
      end
    end

    app1 = nil
    app2 = nil
    app3 = nil

    for j in 0...apps.total_count
      work_id = apps.workspace_id_calculated(j)
      for i in 0...spaces.total_count
        if spaces.id(i) == work_id && spaces.type(i) == $enum_type[:national] && spaces.area(i) == $enum_area[:igcdp]
          case apps.name(j)
            when $enum_iGCDP_apps_name[:open] then app1 = OpportunityDAO.new(apps.id(j))
            when $enum_iGCDP_apps_name[:project] then app2 = OpportunityDAO.new(apps.id(j))
            when $enum_iGCDP_apps_name[:history] then app3 = OpportunityDAO.new(apps.id(j))
          end
        end
      end
    end
    @national_apps = [app1,app2,app3]

  end

  def flow
    local_national_sync
  end


  def local_national_sync
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    national_opens_map = {}
    national_projects_map = {}
    national_opens = @national_apps[0]
    national_projects = @national_apps[1]
    national_history = @national_apps[2]

    national_opens.find_all.each do |national_open|
      national_opens_map[national_open.expa_id] = national_open
    end

    for entity in @entities1 do
      local_opens = @local_apps_ids1[entity][:app1]
      local_projects = @local_apps_ids1[entity][:app2]
      local_history = @local_apps_ids1[entity][:app3]

      local_opens.find_newbies.each do |newbie|
        if national_opens.new_open?(newbie)
          national = national_opens.new_model(newbie.to_h)
          national.expa_id = national_opens.get_id(national)
          national.situation = 2
          national.local_entity = entity
          national.local_reference = newbie.id
          national.id = nil
          national.create
          national_opens_map[national.expa_id] = national

          newbie.situation = 2
          newbie.update
        else
          puts 'Novo Open que já existe nacionalmente' #TODO Mensagem
        end
      end

      #Local Project Update ()
      local_opens.find_all.each do |local_open|
        national_open = national_opens_map[local_opens.get_id(local_open)]
        next if national_open.nil?
        if national_opens.local_open_updated?(national_open,local_open)
          local_open.opens = national_opens.update_local_opens(national_open,local_open)
          local_open.update
        end
      end

      #Local Project Update ()
      local_projects.find_all.each do |local_project|
        national_project = national_projects_map[local_projects.get_id(local_project)]
        next if national_project.nil?
        if national_projects.local_project_updated?(national_project,local_project)
          national_projects.update_local_project(national_project,local_project)
          local_project.update
        end
      end

    end

    #National_Open 2 P (Create Local|National Projects - Delete Local|National Opens)
    national_opens.find_approveds.each do |approved|
      #Creating Local|National Projects
      local_project = @local_apps_ids1[approved.local_entity][:app2].new_model(approved.to_h)
      local_project.create
      national_project = national_projects.new_model(approved.to_h)
      national_project.create

      #Deleting Local|National Opens
      Podio::Item.delete(approved.local_reference)
      approved.delete
    end

    #National Project 2 History (Delete Local|National Project - Create Local|National History)
    national_projects.find_closeds.each do |closed|
      #Creating Local|National History
      local_closed = @local_apps_ids1[closed.local_entity][:app3].new_model(closed.to_h)
      local_closed.create
      national_closed = national_history.new_model(closed.to_h)
      national_closed.create

      #Deleting Local|National Project
      @local_apps_ids1[closed.local_entity][:app2].delete_by_id(closed.local_reference)
      Podio::Item.delete(closed.local_reference)
      closed.delete
    end
  end

end