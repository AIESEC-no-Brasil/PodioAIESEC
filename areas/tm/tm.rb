require_relative '../../control/control_database_workspace'
require_relative '../../control/control_database_app'
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
            when $enum_TM_apps_name[:app1_5] then app1_5 = YouthTalent.new(apps.id(i))
            when $enum_TM_apps_name[:cards] then cards = YouthTalent.new(apps.id(i))
          end
        end

        @local_apps_ids[entity] = [app1, app2, app3, app4, app5, app1_5, cards]
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

    lead_to_approach
    approach_to_rapproach
    stop_rapproach
    rapproach_to_selection
    approach_to_selection

    selection_to_rapproach
    stop_selection
    selection_to_induction


    induction_to_local_crm
  end

  # Migrate leads from the ORS app to all Local Leads Apps
  def ors_to_local
    for entity in @entities do
      abort('Wrong parameter for @ors_app in ' + self.class.name + '.' + __method__.to_s) unless @ors_app.is_a?(YouthTalent)

      limit = @ors_app.total_count
      for i in 0...limit
        if @ors_app.business_rule_ors_to_local_lead?(i,entity)
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

  def lead_to_approach
    for entity in @entities do
      lead = @local_apps_ids[entity][0]
      approach = @local_apps_ids[entity][1]
      abort('Wrong parameter for lead in ' + self.class.name + '.' + __method__.to_s) unless lead.is_a?(YouthTalent)
      abort('Wrong parameter for approach in ' + self.class.name + '.' + __method__.to_s) unless approach.is_a?(YouthTalent)

      limit = lead.total_count
      for i in 0...limit
        if lead.business_rule_lead_to_approach?(i)
          approach.populate(lead,i)
          approach.create
          lead.delete(i)
        end
        lead.refresh_item_list
        approach.refresh_item_list
        @local_apps_ids[entity][0] = lead
        @local_apps_ids[entity][1] = approach
      end
    end
  end

  def approach_to_rapproach
    for entity in @entities do
      approach = @local_apps_ids[entity][1]
      rapproach = @local_apps_ids[entity][5]

      abort('Wrong parameter for approach in ' + self.class.name + '.' + __method__.to_s) unless approach.is_a?(YouthTalent)
      abort('Wrong parameter for rapproach in ' + self.class.name + '.' + __method__.to_s) unless rapproach.is_a?(YouthTalent)

      limit = approach.total_count
      for i in 0...limit
        if approach.business_rule_approach_to_rapproach?(i)
          rapproach.populate(approach,i)
          rapproach.approaches_number=(1)
          rapproach.create
          approach.delete(i)
        end
        approach.refresh_item_list
        rapproach.refresh_item_list
        @local_apps_ids[entity][1] = approach
        @local_apps_ids[entity][5] = rapproach
      end
    end
  end

  def stop_rapproach
    for entity in @entities do
      rapproach = @local_apps_ids[entity][5]

      abort('Wrong parameter for rapproach in ' + self.class.name + '.' + __method__.to_s) unless rapproach.is_a?(YouthTalent)

      limit = rapproach.total_count
      for i in 0...limit
        if rapproach.business_rule_stop_rapproach?(i)
          rapproach.delete(i)
        end

        rapproach.refresh_item_list
        @local_apps_ids[entity][5] = rapproach
      end
    end
  end

  def rapproach_to_selection
    for entity in @entities do
      rapproach = @local_apps_ids[entity][5]
      selection = @local_apps_ids[entity][2]

      abort('Wrong parameter for rapproach in ' + self.class.name + '.' + __method__.to_s) unless rapproach.is_a?(YouthTalent)
      abort('Wrong parameter for selection in ' + self.class.name + '.' + __method__.to_s) unless selection.is_a?(YouthTalent)

      limit = rapproach.total_count
      for i in 0...limit
        if rapproach.business_rule_rapproach_to_selection?(i)
          selection.populate(rapproach,i)
          selection.create
          rapproach.delete(i)
        end

        rapproach.refresh_item_list
        selection.refresh_item_list
        @local_apps_ids[entity][5] = rapproach
        @local_apps_ids[entity][2] = selection
      end
    end
  end

  def approach_to_selection
    for entity in @entities do
      approach = @local_apps_ids[entity][1]
      selection = @local_apps_ids[entity][2]
      abort('Wrong parameter for approach in ' + self.class.name + '.' + __method__.to_s) unless approach.is_a?(YouthTalent)
      abort('Wrong parameter for selection in ' + self.class.name + '.' + __method__.to_s) unless selection.is_a?(YouthTalent)

      limit = approach.total_count
      for i in 0...limit
        if approach.business_rule_approach_to_selection?(i)
          selection.populate(approach,i)
          selection.create
          approach.delete(i)
        end
        approach.refresh_item_list
        selection.refresh_item_list
        @local_apps_ids[entity][1] = approach
        @local_apps_ids[entity][2] = selection
      end
    end
  end

  def selection_to_rapproach
    for entity in @entities do
      selection = @local_apps_ids[entity][2]
      rapproach = @local_apps_ids[entity][5]

      abort('Wrong parameter for selection in ' + self.class.name + '.' + __method__.to_s) unless selection.is_a?(YouthTalent)
      abort('Wrong parameter for rapproach in ' + self.class.name + '.' + __method__.to_s) unless rapproach.is_a?(YouthTalent)

      limit = rapproach.total_count
      for i in 0...limit
        if selection.business_rule_selection_to_rapproach?(i)
          rapproach.populate(selection,i)
          rapproach.create
          selection.delete(i)
        end

        selection.refresh_item_list
        rapproach.refresh_item_list
        @local_apps_ids[entity][2] = selection
        @local_apps_ids[entity][5] = rapproach
      end
    end
  end

  def stop_selection
    for entity in @entities do
      selection = @local_apps_ids[entity][2]

      abort('Wrong parameter for selection in ' + self.class.name + '.' + __method__.to_s) unless selection.is_a?(YouthTalent)

      limit = selection.total_count
      for i in 0...limit
        if selection.business_rule_delete_selection?(i)
          selection.delete(i)
        end

        selection.refresh_item_list
        @local_apps_ids[entity][2] = selection
      end
    end
  end

  def selection_to_induction
    for entity in @entities do
      selection = @local_apps_ids[entity][2]
      induction = @local_apps_ids[entity][3]
      abort('Wrong parameter for selection in ' + self.class.name + '.' + __method__.to_s) unless selection.is_a?(YouthTalent)
      abort('Wrong parameter for induction in ' + self.class.name + '.' + __method__.to_s) unless induction.is_a?(YouthTalent)

      limit = selection.total_count
      for i in 0...limit
        if selection.business_rule_selection_to_induction?(i)
          induction.populate(selection,i)
          induction.create
          selection.delete(i)
        end
      end
      selection.refresh_item_list
      induction.refresh_item_list
      @local_apps_ids[entity][2] = selection
      @local_apps_ids[entity][3] = induction
    end
  end

  def induction_to_local_crm
    for entity in @entities do
      induction = @local_apps_ids[entity][3]
      local_crm = @local_apps_ids[entity][4]
      abort('Wrong parameter for induction in ' + self.class.name + '.' + __method__.to_s) unless induction.is_a?(YouthTalent)
      abort('Wrong parameter for local_crm in ' + self.class.name + '.' + __method__.to_s) unless local_crm.is_a?(YouthTalent)

      limit = induction.total_count
      for i in 0...limit
        if induction.business_rule_induction_to_local_crm?(i)
          local_crm.populate(induction,i)
          local_crm.create
          induction.delete(i)
        end
      end
    end
    induction.refresh_item_list
    local_crm.refresh_item_list
    @local_apps_ids[entity][3] = induction
    @local_apps_ids[entity][4] = local_crm
  end

end
