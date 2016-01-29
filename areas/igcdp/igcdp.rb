require_relative '../../control/control_database_workspace'
require_relative '../../control/control_database_app'
require_relative 'opportunity_dao'

# This class initializes, configure and take care of the tm module.
# The module is divided in 3 categories:
# * 1. ORS ( 1 x )
# * 2. Local ( Number of entities x )
# * 3. National ( 1 x )
class ICX_GCDP
  # @param spaces [ControlDatabaseWorkspace] List of workspaces registered at the IM General
  # @param apps [ControlDatabaseApp] List of apps registered at the IM General
  def initialize(podioDatabase)
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)

    spaces = podioDatabase.workspaces
    apps = podioDatabase.apps
    log = podioDatabase.logs

    config(spaces, apps)
    flow
  end

  def config(spaces,apps)
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    @local_apps_ids1 = {}
    @local_apps_ids2 = {}
    @national_apps = {}

    @entities1 = []
    @entities2 = []
    for i in 0...spaces.total_count
      if !spaces.entity(i).nil? &&
          !spaces.id(i).nil? &&
          spaces.type(i) == $enum_type[:local] &&
          spaces.area(i) == $enum_area[:igcdp]
        @entities1 << spaces.entity(i)
        @local_apps_ids1[spaces.entity(i)] = {:empty => ''}
      end
      if !spaces.entity(i).nil? &&
          !spaces.id2(i).nil? &&
          spaces.type(i) == $enum_type[:local] &&
          spaces.area(i) == $enum_area[:igcdp]
        @entities2 << spaces.entity(i)
        @local_apps_ids2[spaces.entity(i)] = {:empty => ''}
      end
    end
    @entities1.uniq!
    @entities2.uniq!

    for j in 0...apps.total_count
      work_id = apps.workspace_id_calculated(j) || apps.workspace_id2_calculated(j)
      for i in 0...spaces.total_count
        next unless !work_id.nil? && (!spaces.id(i).nil? || !spaces.id2(i).nil?)
        entity = spaces.entity(i)

        if !entity.nil? &&
            spaces.id(i) == work_id &&
            spaces.type(i) == $enum_type[:local] &&
            spaces.area(i) == $enum_area[:igcdp]
          case apps.name(j)
            when $enum_iGCDP_apps_name[:open] then @local_apps_ids1[entity].merge!({:open => OpportunityDAO.new(apps.id(j))})
            when $enum_iGCDP_apps_name[:project] then @local_apps_ids1[entity].merge!({:project => OpportunityDAO.new(apps.id(j))})
            when $enum_iGCDP_apps_name[:history] then @local_apps_ids1[entity].merge!({:history => OpportunityDAO.new(apps.id(j))})
          end

        elsif !entity.nil? &&
            spaces.id2(i) == work_id &&
            spaces.type(i) == $enum_type[:local] &&
            spaces.area(i) == $enum_area[:igcdp]
          case apps.name(j)
            when $enum_iGCDP_apps_name[:open] then @local_apps_ids2[entity].merge!({:open => OpportunityDAO.new(apps.id(j))})
            when $enum_iGCDP_apps_name[:project] then @local_apps_ids2[entity].merge!({:project => OpportunityDAO.new(apps.id(j))})
            when $enum_oGCDP_apps_name[:history] then @local_apps_ids2[entity].merge!({:history => OpportunityDAO.new(apps.id(j))})
          end

        elsif spaces.id(i) == work_id &&
            spaces.type(i) == $enum_type[:national] &&
            spaces.area(i) == $enum_area[:igcdp]
          case apps.name(j)
            when $enum_iGCDP_apps_name[:open] then @national_apps[:open] = OpportunityDAO.new(apps.id(j))
            when $enum_iGCDP_apps_name[:project] then @national_apps[:project] = OpportunityDAO.new(apps.id(j))
            when $enum_iGCDP_apps_name[:history] then @national_apps[:history] = OpportunityDAO.new(apps.id(j))
          end
        end
      end
    end
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
      local_opens = @local_apps_ids1[entity][:open]
      local_projects = @local_apps_ids1[entity][:project]
      local_history = @local_apps_ids1[entity][:history]

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
      local_project = @local_apps_ids1[approved.local_entity][:project].new_model(approved.to_h)
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
      local_closed = @local_apps_ids1[closed.local_entity][:history].new_model(closed.to_h)
      local_closed.create
      national_closed = national_history.new_model(closed.to_h)
      national_closed.create

      #Deleting Local|National Project
      @local_apps_ids1[closed.local_entity][:project].delete_by_id(closed.local_reference)
      Podio::Item.delete(closed.local_reference)
      closed.delete
    end
  end

end