require_relative '../../control/control_database_workspace'
require_relative '../../control/control_database_app'
require_relative '../../enums'
require_relative 'youth_talent'

# This class initializes, configure and take care of the tm module.
# The module is divided in 3 categories:
# * 1. ORS ( 1 x )
# * 2. Local ( Number of entities x )
# * 3. National ( 1 x )
class TM
  # @param spaces [ControlDatabaseWorkspace] List of workspaces registered at the IM General
  # @param apps [ControlDatabaseApp] List of apps registered at the IM General
  def initialize(spaces, apps)
    abort('Wrong parameter for spaces in' + self.class.name + '.' + __method__.to_s) unless spaces.is_a?(ControlDatabaseWorkspace)
    abort('Wrong parameter for apps in ' + self.class.name + '.' + __method__.to_s) unless apps.is_a?(ControlDatabaseApp)

    configORS(spaces,apps)
    configLocals(spaces, apps)
    configNational(spaces, apps)
    flow
  end

  private

  # Detect and configure every ORS workspace and ORS app that is linked to tm
  # @todo research how to raise global variable ors_space_id
  # @todo research how to raise global variable ors_app
  # @param spaces [ControlDatabaseWorkspace] List of workspaces registered at the IM General
  # @param apps [ControlDatabaseApp] List of apps registered at the IM general
  def configORS(spaces, apps)
    limit = spaces.total_count-1
    for i in 0..limit
      if spaces.type(i) == $enum_type[:ors] && spaces.area(i) == $enum_area[:tm]
        @ors_space_id = spaces.id(i)
        break
      end
    end

    limit = apps.total_count-1
    for i in 0..limit
      if apps.type(i) == $enum_type[:ors] && apps.area(i) == $enum_area[:tm]
        @ors_app = YouthTalent.new(apps.id(i))
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

    limit = spaces.total_count-1
    for i in 0..limit
      if spaces.type(i) == $enum_type[:local] && spaces.area(i) == $enum_area[:tm]
        @local_spaces_ids << spaces.id(i)
      end
    end

    @entities = []
    limit = apps.total_count-1
    for i in 0..limit
      if !apps.entity(i).nil? && apps.area(i) == $enum_area[:tm]
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
      for i in 0..apps.total_count-1
        if !apps.entity(i).nil? && apps.entity(i).eql?(entity) && apps.area(i) == $enum_area[:tm]
          case apps.name(i)
            when $enum_TM_apps_name[:app1] then app1 = YouthTalent.new(apps.id(i))
            when $enum_TM_apps_name[:app2] then app2 = YouthTalent.new(apps.id(i))
            when $enum_TM_apps_name[:app3] then app3 = YouthTalent.new(apps.id(i))
            when $enum_TM_apps_name[:app4] then app4 = YouthTalent.new(apps.id(i))
            when $enum_TM_apps_name[:app5] then app5 = YouthTalent.new(apps.id(i))
          end
        end

        @local_apps_ids[entity] = [app1, app2, app3, app4, app5]
      end
    end

  end

  def configNational(spaces, apps)
    limit = spaces.total_count-1
    for i in 0..limit
      if spaces.type(i) == $enum_type[:national] && spaces.area(i) == $enum_area[:tm]
        @national_space_id = spaces.id(i)
        break
      end
    end

    limit = apps.total_count-1
    for i in 0..limit
      if apps.type(i) == $enum_type[:national] && apps.area(i) == $enum_area[:tm]
        @national_app_id = apps.id(i)
        break
      end
    end
  end

  def flow
    ors_to_local
    local_to_local
    #local_to_national
  end

  # Migrate leads from the ORS app to all Local Leads Apps
  def ors_to_local
    for entity in @entities do
      abort('Wrong parameter for @ors_app in ' + self.class.name + '.' + __method__.to_s) unless @ors_app.is_a?(YouthTalent)

      limit = @ors_app.total_count
      for i in 0...limit
        if @ors_app.local_aiesec(i) == entity && @ors_app.can_be_local?(i,entity)
          lead = @local_apps_ids[entity][0]
          abort('Wrong parameter for lead in ' + self.class.name + '.' + __method__.to_s) unless lead.is_a?(YouthTalent)

          lead.populate(@ors_app,i)
          lead.create
          @ors_app.sync_with_local = true
          @ors_app.update(i)
        end
      end
    end
  end

  # For all local apps, move the registers through customer flow.
  def local_to_local
    lead_to_contacted
    contacted_to_dynamics
    dynamics_to_interview
    interview_to_member
  end

  def lead_to_contacted
    for entity in @entities do
      lead = @local_apps_ids[entity][0]
      contacted = @local_apps_ids[entity][1]
      abort('Wrong parameter for lead in ' + self.class.name + '.' + __method__.to_s) unless lead.is_a?(YouthTalent)
      abort('Wrong parameter for contacted in ' + self.class.name + '.' + __method__.to_s) unless contacted.is_a?(YouthTalent)

      limit = lead.total_count
      for i in 0...limit
        if lead.can_be_contacted?(i)
          contacted.populate(lead,i)
          contacted.create
          lead.delete(i)
        end
        lead.refresh_item_list
        contacted.refresh_item_list
        @local_apps_ids[entity][0] = lead
        @local_apps_ids[entity][1] = contacted
      end
    end
  end

  def contacted_to_dynamics
    for entity in @entities do
      contacted = @local_apps_ids[entity][1]
      dynamics = @local_apps_ids[entity][2]
      abort('Wrong parameter for contacted in ' + self.class.name + '.' + __method__.to_s) unless contacted.is_a?(YouthTalent)
      abort('Wrong parameter for dynamics in ' + self.class.name + '.' + __method__.to_s) unless dynamics.is_a?(YouthTalent)

      limit = contacted.total_count
      for i in 0...limit
        if contacted.can_be_dynamics?(i) 
          dynamics.populate(contacted,i)
          dynamics.create
          contacted.delete(i)
        end
        contacted.refresh_item_list
        dynamics.refresh_item_list
        @local_apps_ids[entity][1] = contacted
        @local_apps_ids[entity][2] = dynamics
      end
    end
  end

  def dynamics_to_interview
    for entity in @entities do
      dynamics = @local_apps_ids[entity][2]
      interview = @local_apps_ids[entity][3]
      abort('Wrong parameter for dynamics in ' + self.class.name + '.' + __method__.to_s) unless dynamics.is_a?(YouthTalent)
      abort('Wrong parameter for interview in ' + self.class.name + '.' + __method__.to_s) unless interview.is_a?(YouthTalent)

      limit = dynamics.total_count
      for i in 0...limit
        if dynamics.can_be_interviewed?(i)
          interview.populate(dynamics,i)
          interview.create
          dynamics.delete(i)
        end
      end
      dynamics.refresh_item_list
      interview.refresh_item_list
      @local_apps_ids[entity][2] = dynamics
      @local_apps_ids[entity][3] = interview
    end
  end

  def interview_to_member
    for entity in @entities do
      interview = @local_apps_ids[entity][3]
      member = @local_apps_ids[entity][4]
      abort('Wrong parameter for interview in ' + self.class.name + '.' + __method__.to_s) unless interview.is_a?(YouthTalent)
      abort('Wrong parameter for member in ' + self.class.name + '.' + __method__.to_s) unless member.is_a?(YouthTalent)

      limit = interview.total_count
      for i in 0...limit
        if interview.can_be_member?(i)
          member.populate(interview,i)
          member.create
          interview.delete(i)
        end
      end
    end
    interview.refresh_item_list
    member.refresh_item_list
    @local_apps_ids[entity][3] = interview
    @local_apps_ids[entity][4] = member
  end

  def local_to_national
  end

end
