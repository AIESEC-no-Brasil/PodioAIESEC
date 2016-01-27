require_relative '../../control/control_database_workspace'
require_relative '../../control/control_database_app'
require_relative 'gip_opportunity_dao'

# This class initializes, configure and take care of the tm module.
# The module is divided in 3 categories:
# * 1. ORS ( 1 x )
# * 2. Local ( Number of entities x )
# * 3. National ( 1 x )
class GIPOpportunity
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
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)

    for i in 0...spaces.total_count
      if spaces.type(i) == $enum_type[:ors] && spaces.area(i) == $enum_area[:igip]
        @ors_space_id = spaces.id(i)
        break
      end
    end

    for j in 0...apps.total_count
      work_id = apps.workspace_id_calculated(j)
      for i in 0...spaces.total_count
        if spaces.id(i) == work_id && spaces.type(i) == $enum_type[:ors] && spaces.area(i) == $enum_area[:igip]
          @ors = GlobalCitizenDAO.new(apps.id(j))
          break
        end
      end
    end
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
      if spaces.type(i) == $enum_type[:local] && spaces.area(i) == $enum_area[:igip]
        @local_spaces_ids[spaces.id(i)] = nil
      end
    end

    @entities1 = []
    for j in 0...apps.total_count
      work_id = apps.workspace_id_calculated(j)
      for i in 0...spaces.total_count
        if spaces.id(i) == work_id && !spaces.entity(i).nil? && spaces.area(i) == $enum_area[:igip]
          @entities1 << spaces.entity(i)
        end
      end
    end

    @entities1.uniq!
    for entity in @entities1 do
      app1 = nil
      app2 = nil
      app3 = nil
      app4 = nil
      app5 = nil
      for j in 0...apps.total_count
        work_id = apps.workspace_id_calculated(j)
        for i in 0...spaces.total_count
          if spaces.id(i) == work_id && !spaces.entity(i).nil? && spaces.entity(i).eql?(entity) && spaces.area(i) == $enum_area[:igip]
            case apps.name(j)
              when $enum_iGIP_apps_name[:open] then app1 = GIPOpportunityDAO.new(apps.id(j))
              when $enum_iGIP_apps_name[:in_progress] then app2 = GIPOpportunityDAO.new(apps.id(j))
              when $enum_iGIP_apps_name[:match] then app3 = GIPOpportunityDAO.new(apps.id(j))
              when $enum_iGIP_apps_name[:realize] then app4 = GIPOpportunityDAO.new(apps.id(j))
              when $enum_iGIP_apps_name[:history] then app5 = GIPOpportunityDAO.new(apps.id(j))
            end
          end
          @local_apps_ids1[entity] = {:app1 => app1,
                                      :app2 => app2,
                                      :app3 => app3,
                                      :app4 => app4,
                                      :app5 => app5}

        end
      end
    end

  end

  def configNational(spaces, apps)
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)

    for i in 0...spaces.total_count
      if spaces.type(i) == $enum_type[:national] && spaces.area(i) == $enum_area[:igip]
        @national_space_id = spaces.id(i)
        break
      end
    end

    app1 = nil
    app2 = nil
    app3 = nil
    app4 = nil
    app5 = nil

    for j in 0...apps.total_count
      work_id = apps.workspace_id_calculated(j)
      for i in 0...spaces.total_count
        if spaces.id(i) == work_id && spaces.type(i) == $enum_type[:national] && spaces.area(i) == $enum_area[:igip]
          case apps.name(j)
            when $enum_iGIP_apps_name[:open] then app1 = GIPOpportunityDAO.new(apps.id(j))
            when $enum_iGIP_apps_name[:in_progress] then app2 = GIPOpportunityDAO.new(apps.id(j))
            when $enum_iGIP_apps_name[:match] then app3 = GIPOpportunityDAO.new(apps.id(j))
            when $enum_iGIP_apps_name[:realize] then app4 = GIPOpportunityDAO.new(apps.id(j))
            when $enum_iGIP_apps_name[:history] then app5 = GIPOpportunityDAO.new(apps.id(j))
          end
        end
      end
    end
    @national_apps = [app1,app2,app3,app4]

  end

  def flow
    local_national_sync
  end

  def local_national_sync
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    national_opens_map = {}
    national_match_map = {}
    national_realize_map = {}
    national_opens = @national_apps[0]
    national_in_progress = @national_apps[1]
    national_matchs = @national_apps[2]
    national_realizes = @national_apps[3]
    national_histories = @national_apps[4]

    national_opens.find_all.each do |national_open|
      national_opens_map[national_open.expa_id] = national_open
    end

    national_matchs.find_all.each do |national_match|
      national_match_map[national_match.expa_id] = national_match
    end

    national_realizes.find_all.each do |national_realize|
      national_realize_map[national_realize.expa_id] = national_realize
    end



    for entity in @entities1 do
      local_opens = @local_apps_ids1[entity][:app1]
      local_in_progress = @local_apps_ids1[entity][:app2]
      local_matchs = @local_apps_ids1[entity][:app3]
      local_realizes = @local_apps_ids1[entity][:app4]
      local_histories = @local_apps_ids1[entity][:app5]

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
          puts newbie.expa_link['url']
        end
      end

      #Local Opens Update ()
      local_opens.find_all.each do |local_open|
        national_open = national_opens_map[local_opens.get_id(local_open)]
        next if national_open.nil?
        national_opens.sync_open(local_open,national_open)
      end

      #Local Matchs Upgrade ()
      local_matchs.find_all.each do |local_match|
        national_match = national_match_map[local_matchs.get_id(local_match)]
        next if national_match.nil?
        national_matchs.sync_match(local_match,national_match)

        if national_matchs.can_be_realize?(local_match)
          national_realize = national_realizes.new_model(national_match.to_h)
          national_realize.expa_id = national_realizes.get_id(national_match)
          national_realize.id = nil
          local_realize = local_realizes.new_model(national_realize.to_h)

          national_realize.create
          local_realize.create
          national_realize_map[national_realize.expa_id] = national_realize

          national_match_map.delete(national_match.expa_id)
          national_match.delete
          local_match.delete
        end
      end

      #Local Realizes Upgrade ()
      local_realizes.find_all.each do |local_realize|
        national_realize = national_realize_map[local_realizes.get_id(local_realize)]
        next if national_realize.nil?
        national_realizes.sync_realize(local_realize,national_realize)

        if national_realizes.can_be_history?(local_realize)
          national_history = national_histories.new_model(national_realize.to_h)
          national_history.expa_id = national_histories.get_id(national_realize)
          national_history.id = nil
          local_history = local_histories.new_model(national_history.to_h)

          national_history.create
          local_history.create

          national_realize_map.delete(national_realize.expa_id)
          national_realize.delete
          local_realize.delete
        end
      end

    end

    #National_Open 2 P (Create Local|National Projects - Delete Local|National Opens)
    national_opens.find_approveds.each do |approved|
      #Creating Local|National Projects
      local_match = @local_apps_ids1[approved.local_entity][:app2].new_model(approved.to_h)
      local_match.create
      national_match = national_matchs.new_model(approved.to_h)
      national_match.create

      #Deleting Local|National Opens
      Podio::Item.delete(approved.local_reference)
      approved.delete
    end
  end
end