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
    abort('Wrong parameter for spaces in ' + self.class.name + '.' + __method__.to_s) unless spaces.is_a?(ControlDatabaseWorkspace)
    abort('Wrong parameter for apps in ' + self.class.name + '.' + __method__.to_s) unless apps.is_a?(ControlDatabaseApp)

    #configORS(spaces,apps)
    configLocals(spaces, apps)
    configNational(spaces, apps)
    flow
  end

  # Detect and configure every ORS workspace and ORS app that is linked to tm
  # @todo research how to raise global variable ors_space_id
  # @todo research how to raise global variable ors_app
  # @param spaces [ControlDatabaseWorkspace] List of workspaces registered at the IM General
  # @param apps [ControlDatabaseApp] List of apps registered at the IM general
  def configORS(spaces, apps)
    puts 'configORS'
    limit = spaces.total_count-1
    for i in 0..limit
      if spaces.type(i) == $enum_type[:ors] && spaces.area(i) == $enum_area[:igcdp]
        @ors_space_id = spaces.id(i)
        break
      end
    end

    limit = apps.total_count-1
    for i in 0..limit
      if apps.type(i) == $enum_type[:ors] && apps.area(i) == $enum_area[:igcdp]
        @ors = GlobalCitizenDAO.new(apps.id(i))
        break
      end
    end
  end

  # Detect and configure every Locals workspaces and Locals apps taht are linkted to tm
  # @todo research how to raise global array local_spaces_ids
  # @todo research how to raise global hash local_apps_ids
  # @param spaces [ControlDatabaseWorkspace] List of workspaces registered at the IM General
  # @param apps [ControlDatabaseApp] List of apps registered at the IM general
  def configLocals(spaces, apps)
    @local_spaces_ids = []
    @local_apps_ids = {}

    limit = spaces.total_count - 1
    for i in 0..limit
      if spaces.type(i) == $enum_type[:local] && spaces.area(i) == $enum_area[:igcdp]
        @local_spaces_ids << spaces.id(i)
      end
    end

    @entities = []
    limit = apps.total_count - 1
    for i in 0..limit
      if !apps.entity(i).nil? && apps.area(i) == $enum_area[:igcdp]
        @entities << apps.entity(i)
      end
    end

    @entities.uniq!

    for entity in @entities do
      app1 = nil
      app2 = nil
      app3 = nil
      app4 = nil
      app5 = nil
      app6 = nil
      for i in 0..apps.total_count - 1
        if !apps.entity(i).nil? && apps.entity(i).eql?(entity) && apps.area(i) == $enum_area[:igcdp]
          case apps.name(i)
            when $enum_iGCDP_apps_name[:open] then app1 = OpportunityDAO.new(apps.id(i))
            when $enum_iGCDP_apps_name[:project] then app2 = OpportunityDAO.new(apps.id(i))
            when $enum_iGCDP_apps_name[:history] then app3 = OpportunityDAO.new(apps.id(i))
          end
        end
      end
      @local_apps_ids[entity] = [app1,app2,app3,app4,app5,app6]
    end

  end

  def configNational(spaces, apps)
    limit = spaces.total_count - 1
    (0..limit).each do |i|
      if spaces.type(i) == $enum_type[:national] && spaces.area(i) == $enum_area[:igcdp]
        @national_space_id = spaces.id(i)
        break
      end
    end

    app1 = nil
    app2 = nil
    app3 = nil
    limit = apps.total_count - 1
    (0..limit).each do |i|
      if apps.type(i) == $enum_type[:national] && apps.area(i) == $enum_area[:igcdp]
        case apps.name(i)
          when $enum_iGCDP_apps_name[:open] then app1 = OpportunityDAO.new(apps.id(i))
          when $enum_iGCDP_apps_name[:project] then app2 = OpportunityDAO.new(apps.id(i))
          when $enum_iGCDP_apps_name[:history] then app3 = OpportunityDAO.new(apps.id(i))
        end
      end
    end
    @national_apps = [app1,app2,app3]
    puts @national_apps
  end

  def flow
    #ors_to_local
    #local_to_local
    local_national_sync
  end

  # Migrate leads from the ORS app to all Local Leads Apps
  def ors_to_local
  end

  # For all local apps, move the registers through customer flow.
  def local_to_local
  end

  def local_national_sync
    national_opens = @national_apps[0]
    national_projects = @national_apps[1]
    national_history = @national_apps[2]
    for entity in @entities do
      local_opens = @local_apps_ids[entity][0]
      local_projects = @local_apps_ids[entity][1]
      local_history = @local_apps_ids[entity][2]

      local_opens.find_newbies.each do |newbie|
        if national_opens.new_open?(newbie)
          national = national_opens.new_model(newbie.to_h)
          national.expa_id = national_opens.get_id(national)
          national.situation = 2
          national.local_entity = entity
          national.local_reference = newbie.id
          #national.expa_link = nil
          national.id = nil
          puts national.to_h
          national.create

          newbie.situation = 2
          newbie.update
        else
          puts 'Novo Open que já existe nacionalmente' #TODO Mensagem
        end
      end
      
      #Local Project Update ()

    end

    #National_Open 2 P (Create Local|National Projects - Delete Local|National Opens)
    national_opens.find_approveds.each do |approved|
      #Creating Local|National Projects
      local_project = @local_apps_ids[approved.local_entity][1].new_model(approved.to_h)
      local_project.create
      national_project = national_projects.new_model(approved.to_h)
      national_project.create

      #Deleting Local|National Opens
      @local_apps_ids[approved.local_entity][0].delete_by_id(approved.local_reference)
      approved.delete
    end

    #National Project 2 History (Delete Local|National Project - Create Local|National History)
    national_projects.find_closeds.each do |closed|
      #Creating Local|National History
      local_closed = @local_apps_ids[closed.local_entity][2].new_model(closed.to_h)
      local_closed.create
      national_closed = national_history.new_model(closed.to_h)
      national_closed.create

      #Deleting Local|National Project
      @local_apps_ids[closed.local_entity][0].delete_by_id(closed.local_reference)
      closed.delete
    end
  end

end
