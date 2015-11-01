require_relative '../../control/control_database_workspace'
require_relative '../../control/control_database_app'
require_relative 'youth_talent_dao'

# This class initializes, configure and take care of the tm module.
# The module is divided in 3 categories:
# * 1. ORS ( 1 x )
# * 2. Local ( Number of entities x )
# * 3. National ( 1 x )
class TM
  # @param spaces [ControlDatabaseWorkspace] List of workspaces registered at the IM General
  # @param apps [ControlDatabaseApp] List of apps registered at the IM General
  def initialize(spaces, apps)
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
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
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    limit = spaces.total_count
    for i in 0...limit
      if spaces.type(i) == $enum_type[:ors] && spaces.area(i) == $enum_area[:tm]
        @ors_space_id = spaces.id(i)
        break
      end
    end

    limit = apps.total_count
    for i in 0...limit
      if apps.type(i) == $enum_type[:ors] && apps.area(i) == $enum_area[:tm]
        @ors = YouthTalentDAO.new(apps.id(i))
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
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
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
      app2_5 = nil
      cards = nil
      for i in 0..apps.total_count-1
        if !apps.entity(i).nil? && apps.entity(i).eql?(entity) && apps.area(i) == $enum_area[:tm]
          case apps.name(i)
            when $enum_TM_apps_name[:app1] then app1 = YouthTalentDAO.new(apps.id(i))
            when $enum_TM_apps_name[:app2] then app2 = YouthTalentDAO.new(apps.id(i))
            when $enum_TM_apps_name[:app3] then app3 = YouthTalentDAO.new(apps.id(i))
            when $enum_TM_apps_name[:app4] then app4 = YouthTalentDAO.new(apps.id(i))
            when $enum_TM_apps_name[:app5] then app5 = YouthTalentDAO.new(apps.id(i))
            when $enum_TM_apps_name[:app2_5] then app2_5 = YouthTalentDAO.new(apps.id(i))
            when $enum_TM_apps_name[:cards] then cards = YouthTalentDAO.new(apps.id(i))
          end
        end

        @local_apps_ids[entity] = [app1, app2, app3, app4, app5, app2_5, cards]
      end
    end

  end

  def configNational(spaces, apps)
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
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
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    ors_to_local

    lead_to_approach

    approach_to_rapproach
    selection_to_rapproach
    stop_rapproach

    rapproach_to_selection
    approach_to_selection
    stop_selection

    selection_to_induction

    induction_to_local_crm
  end

  # Migrate leads from the ORS app to all Local Leads Apps
  def ors_to_local
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    models_list = @ors.find_ors_to_local_lead
    models_list.each do |national_lead|
      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      next unless not @local_apps_ids[national_lead.local_aiesec].nil?
      local_leads = @local_apps_ids[national_lead.local_aiesec][0]

      abort('Wrong parameter for leads in ' + self.class.name + '.' + __method__.to_s) unless local_leads.is_a?(YouthTalentDAO)

      local_lead = local_leads.new_model(national_lead.to_h)
      local_lead.create
      national_lead.sync_with_local = 2
      national_lead.update
    end
  end

  def lead_to_approach
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      leads = @local_apps_ids[entity][0]
      approach = @local_apps_ids[entity][1]
      abort('Wrong parameter for lead in ' + self.class.name + '.' + __method__.to_s) unless leads.is_a?(YouthTalentDAO)
      abort('Wrong parameter for approach in ' + self.class.name + '.' + __method__.to_s) unless approach.is_a?(YouthTalentDAO)

      leads.find_all.each do |lead|
        sleep(3600) unless $podio_flag == true
        $podio_flag = true
        if leads.business_rule_lead_to_approach?(lead)
          approached = approach.new_model(lead.to_h)
          approached.create
          lead.delete
        end
      end
    end
  end

  def approach_to_rapproach
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      approach = @local_apps_ids[entity][1]
      rapproach = @local_apps_ids[entity][5]
      abort('Wrong parameter for approach in ' + self.class.name + '.' + __method__.to_s) unless approach.is_a?(YouthTalentDAO)
      abort('Wrong parameter for rapproach in ' + self.class.name + '.' + __method__.to_s) unless rapproach.is_a?(YouthTalentDAO)

      approach.find_all.each do |approached|
        sleep(3600) unless $podio_flag == true
        $podio_flag = true
        if approach.business_rule_approach_to_rapproach?(approached)
          rapproached = rapproach.new_model(approached.to_h)
          rapproached.approaches_number = 1
          rapproached.create
          approached.delete
        end
      end
    end
  end

  def stop_rapproach
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      rapproach = @local_apps_ids[entity][5]
      abort('Wrong parameter for rapproach in ' + self.class.name + '.' + __method__.to_s) unless rapproach.is_a?(YouthTalentDAO)

      rapproach.find_all.each do |rapproached|
        sleep(3600) unless $podio_flag == true
        $podio_flag = true
        if rapproach.business_rule_stop_rapproach?(rapproached)
          rapproached.delete
        end
      end
    end
  end

  def rapproach_to_selection
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      rapproach = @local_apps_ids[entity][5]
      selection = @local_apps_ids[entity][2]
      abort('Wrong parameter for rapproach in ' + self.class.name + '.' + __method__.to_s) unless rapproach.is_a?(YouthTalentDAO)
      abort('Wrong parameter for selection in ' + self.class.name + '.' + __method__.to_s) unless selection.is_a?(YouthTalentDAO)

      rapproach.find_all.each do |rapproached|
        sleep(3600) unless $podio_flag == true
        $podio_flag = true
        if rapproach.business_rule_rapproach_to_selection?(rapproached)
          selected = selection.new_model(rapproached.to_h)
          selected.create
          rapproached.delete
        end
      end
    end
  end

  def approach_to_selection
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      approach = @local_apps_ids[entity][1]
      selection = @local_apps_ids[entity][2]
      abort('Wrong parameter for approach in ' + self.class.name + '.' + __method__.to_s) unless approach.is_a?(YouthTalentDAO)
      abort('Wrong parameter for selection in ' + self.class.name + '.' + __method__.to_s) unless selection.is_a?(YouthTalentDAO)

      approach.find_all.each do |approached|
        sleep(3600) unless $podio_flag == true
        $podio_flag = true
        if approach.business_rule_approach_to_selection?(approached)
          selected = selection.new_model(approached.to_h)
          selected.create
          approached.delete
        end
      end
    end
  end

  def selection_to_rapproach
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      selection = @local_apps_ids[entity][2]
      rapproach = @local_apps_ids[entity][5]
      abort('Wrong parameter for selection in ' + self.class.name + '.' + __method__.to_s) unless selection.is_a?(YouthTalentDAO)
      abort('Wrong parameter for rapproach in ' + self.class.name + '.' + __method__.to_s) unless rapproach.is_a?(YouthTalentDAO)

      selection.find_all.each do |selected|
        sleep(3600) unless $podio_flag == true
        $podio_flag = true
        if selection.business_rule_selection_to_rapproach?(selected)
          rapproached = rapproach.new_model(selected.to_h)
          rapproached.create
          selected.delete
        end
      end
    end
  end

  def stop_selection
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      selection = @local_apps_ids[entity][2]
      abort('Wrong parameter for selection in ' + self.class.name + '.' + __method__.to_s) unless selection.is_a?(YouthTalentDAO)

      selection.find_all.each do |selected|
        sleep(3600) unless $podio_flag == true
        $podio_flag = true
        if selection.business_rule_delete_selection?(selected)
          selected.delete
        end
      end
    end
  end

  def selection_to_induction
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      selection = @local_apps_ids[entity][2]
      induction = @local_apps_ids[entity][3]
      abort('Wrong parameter for selection in ' + self.class.name + '.' + __method__.to_s) unless selection.is_a?(YouthTalentDAO)
      abort('Wrong parameter for induction in ' + self.class.name + '.' + __method__.to_s) unless induction.is_a?(YouthTalentDAO)

      selection.find_all.each do |selected|
        sleep(3600) unless $podio_flag == true
        $podio_flag = true
        if selection.business_rule_selection_to_induction?(selected)
          inducted = induction.new_model(selected.to_h)
          inducted.create
          selected.delete
        end
      end
    end
  end

  def induction_to_local_crm
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      induction = @local_apps_ids[entity][3]
      local_crm = @local_apps_ids[entity][4]
      abort('Wrong parameter for induction in ' + self.class.name + '.' + __method__.to_s) unless induction.is_a?(YouthTalentDAO)
      abort('Wrong parameter for local_crm in ' + self.class.name + '.' + __method__.to_s) unless local_crm.is_a?(YouthTalentDAO)

      induction.find_all.each do |inducted|
        sleep(3600) unless $podio_flag == true
        $podio_flag = true
        if induction.business_rule_induction_to_local_crm?(inducted)
          client = local_crm.new_model(inducted.to_h)
          client.create
          inducted.delete
        end
      end
    end
  end

end