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

    config(spaces,apps)
    flow
    #TODO passagem de um CL para outro
  end

  private

  def config(spaces, apps)
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    @local_spaces_ids = {}
    @local_apps_ids = {}
    @national_apps = {}

    @entities = []
    for i in 0...spaces.total_count
      if !spaces.entity(i).nil? &&
          !spaces.id(i).nil? &&
          spaces.type(i) == $enum_type[:local] &&
          spaces.area(i) == $enum_area[:tm]
        @entities << spaces.entity(i)
        @local_apps_ids[spaces.entity(i)] = {:empty => ''}
      end
    end
    @entities.uniq!

    for j in 0...apps.total_count
      work_id = apps.workspace_id_calculated(j)
      for i in 0...spaces.total_count
        next unless !work_id.nil? && !spaces.id(i).nil?
        entity = spaces.entity(i)

        if spaces.id(i) == work_id &&
            spaces.type(i) == $enum_type[:ors] &&
            spaces.area(i) == $enum_area[:tm]
          @ors = YouthTalentDAO.new(apps.id(j))

        elsif !entity.nil? &&
              spaces.id(i) == work_id &&
              spaces.type(i) == $enum_type[:local] &&
              spaces.area(i) == $enum_area[:tm]
          case apps.name(j)
            when $enum_TM_apps_name[:app1] then @local_apps_ids[entity].merge!({:app1 => YouthTalentDAO.new(apps.id(j))})
            when $enum_TM_apps_name[:app2] then @local_apps_ids[entity].merge!({:app2 => YouthTalentDAO.new(apps.id(j))})
            when $enum_TM_apps_name[:app3] then @local_apps_ids[entity].merge!({:app3 => YouthTalentDAO.new(apps.id(j))})
            when $enum_TM_apps_name[:app4] then @local_apps_ids[entity].merge!({:app4 => YouthTalentDAO.new(apps.id(j))})
            when $enum_TM_apps_name[:app5] then @local_apps_ids[entity].merge!({:app5 => YouthTalentDAO.new(apps.id(j))})
            when $enum_TM_apps_name[:app2_5] then @local_apps_ids[entity].merge!({:app2_5 => YouthTalentDAO.new(apps.id(j))})
          end

        elsif spaces.id(i) == work_id &&
              spaces.type(i) == $enum_type[:national] &&
              spaces.area(i) == $enum_area[:tm]
          case apps.name(j)
            when $enum_TM_apps_name[:app1] then @national_apps[:app1] = YouthTalentDAO.new(apps.id(j))
            when $enum_TM_apps_name[:app2] then @national_apps[:app2] = YouthTalentDAO.new(apps.id(j))
            when $enum_TM_apps_name[:app3] then @national_apps[:app3] = YouthTalentDAO.new(apps.id(j))
            when $enum_TM_apps_name[:app4] then @national_apps[:app4] = YouthTalentDAO.new(apps.id(j))
            when $enum_TM_apps_name[:app5] then @national_apps[:app5] = YouthTalentDAO.new(apps.id(j))
            when $enum_TM_apps_name[:app2_5] then @national_apps[:app2_5] = YouthTalentDAO.new(apps.id(j))
          end
        end
      end

    end

  end

  def flow
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    ors_to_local
    local_to_local
  end

  # Migrate leads from the ORS app to all Local Leads Apps
  def ors_to_local
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    models_list = @ors.find_ors_to_local_lead
    models_list.each do |national_ors|
      sleep(3600) unless $podio_flag == true
      $podio_flag = true

      next unless @local_apps_ids.has_key?(national_ors.local_aiesec)
      local_leads = @local_apps_ids[national_ors.local_aiesec][:app1]
      abort('Wrong parameter for leads in ' + self.class.name + '.' + __method__.to_s) unless local_leads.is_a?(YouthTalentDAO)
      puts(self.class.name + '.' + __method__.to_s + ' ~ ' + national_ors.local_aiesec.to_s + ' - ' + Time.now.utc.to_s)

      local_lead = local_leads.new_model(national_ors.to_h)
      local_lead.lead_date = {'start' => Time.new.strftime('%Y-%m-%d %H:%M:%S')}
      national_app1 = @national_apps[:app1].new_model(national_ors.to_h)
      national_app1.lead_date = {'start' => Time.new.strftime('%Y-%m-%d %H:%M:%S')}
      national_ors.sync_with_local = 2

      begin
        national_ors.id_local = national_app1.id_local = local_lead.create
        national_app1.create
        national_ors.update
      rescue => exception
        puts 'ERROR'
        puts exception.backtracce
        puts 'ERROR'
      end
    end
  end

  def local_to_local
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      puts(self.class.name + '.' + __method__.to_s + ' ~ ' + entity.to_s + ' - ' + Time.now.utc.to_s)
      leads = @local_apps_ids[entity][:app1]
      approaches = @local_apps_ids[entity][:app2]
      rapproaches = @local_apps_ids[entity][:app2_5]
      selectiones = @local_apps_ids[entity][:app3]
      inductiones = @local_apps_ids[entity][:app4]
      local_crms = @local_apps_ids[entity][:app5]

      abort('Wrong parameter for leads in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless leads.is_a?(YouthTalentDAO)
      abort('Wrong parameter for approaches in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless approaches.is_a?(YouthTalentDAO)
      abort('Wrong parameter for rapproaches in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless rapproaches.is_a?(YouthTalentDAO)
      abort('Wrong parameter for selectiones in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless selectiones.is_a?(YouthTalentDAO)
      abort('Wrong parameter for inductiones in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless inductiones.is_a?(YouthTalentDAO)
      abort('Wrong parameter for local_crms in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless local_crms.is_a?(YouthTalentDAO)

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      leads.find_all.each do |lead|
        if leads.business_rule_lead_to_approach?(lead)
          approached = approaches.new_model(lead.to_h)
          national_app1 = @national_apps[:app1]
          national_app2 = @national_apps[:app2]
          national_app1 = national_app1.find_national_local_id(lead.id)[0]
          national_app2 = national_app2.new_model(lead.to_h)


          begin
            national_app2.id_local = approached.create
            national_app2.create
            national_app1.delete unless national_app1.nil?
            lead.delete unless lead.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.backtracce
            puts 'ERROR'
          end
        end
      end

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      approaches.find_all.each do |approached|
        if approaches.business_rule_approach_to_rapproach?(approached)
          rapproached = rapproaches.new_model(approached.to_h)
          national_app2 = @national_apps[:app2]
          national_app2_5 = @national_apps[:app2_5]
          national_app2 = national_app2.find_national_local_id(approached.id)[0]
          national_app2_5 = national_app2_5.new_model(approached.to_h)
          rapproached.approaches_number = 1
          national_app2_5.approaches_number = 1

          begin
            national_app2_5.id_local = rapproached.create
            national_app2_5.create
            national_app2.delete unless national_app2.nil?
            approached.delete unless approached.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.backtracce
            puts 'ERROR'
          end
        end

        if approaches.business_rule_approach_to_selection?(approached)
          selected = selectiones.new_model(approached.to_h)
          national_app2 = @national_apps[:app2]
          national_app3 = @national_apps[:app3]
          national_app2 = national_app2.find_national_local_id(approached.id)[0]
          national_app3 = national_app3.new_model(approached.to_h)

          begin
            national_app3.id_local = selected.create
            national_app3.create
            national_app2.delete unless national_app2.nil?
            approached.delete unless approached.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.backtracce
            puts 'ERROR'
          end

        end
      end

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      rapproaches.find_all.each do |rapproached|
        if rapproaches.business_rule_stop_rapproach?(rapproached)
          national_app2_5 = @national_apps[:app2_5]
          national_app2_5 = national_app2_5.find_national_local_id(rapproached.id)[0]

          begin
            national_app2_5.delete unless national_app2_5.nil?
            rapproached.delete unless rapproached.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.backtracce
            puts 'ERROR'
          end
        end

        if rapproaches.business_rule_rapproach_to_selection?(rapproached)
          selected = selectiones.new_model(rapproached.to_h)
          national_app2_5 = @national_apps[:app2_5]
          national_app3 = @national_apps[:app3]
          national_app2_5 = national_app2_5.find_national_local_id(rapproached.id)[0]
          national_app3 = national_app3.new_model(rapproached.to_h)
          selected.responsable = rapproached.responsable_new_contact
          selected.first_approach_date = rapproached.next_contact_date
          national_app3.responsable = rapproached.responsable_new_contact
          national_app3.first_approach_date = rapproached.next_contact_date

          begin
            national_app3.id_local = selected.create
            national_app3.create
            national_app2_5.delete unless national_app2_5.nil?
            rapproached.delete unless rapproached.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.backtracce
            puts 'ERROR'
          end
        end
      end

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      selectiones.find_all.each do |selection|
        if selectiones.business_rule_selection_to_rapproach?(selection)
          rapproached = rapproaches.new_model(selection.to_h)
          national_app3 = @national_apps[:app3]
          national_app2_5 = @national_apps[:app2_5]
          national_app3 = national_app3.find_national_local_id(selection.id)[0]
          national_app2_5 = national_app2_5.new_model(selection.to_h)

          begin
            national_app2_5.id_local = rapproached.create
            national_app2_5.create
            national_app3.delete unless national_app3.nil?
            selection.delete unless selection.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.backtracce
            puts 'ERROR'
          end
        end

        if selectiones.business_rule_delete_selection?(selection)
          national_app3 = @national_apps[:app3]
          national_app3 = national_app3.find_national_local_id(selection.id)[0]

          begin
            national_app3.delete unless national_app3.nil?
            selected.delete unless selected.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.backtracce
            puts 'ERROR'
          end
        end

        if selectiones.business_rule_selection_to_induction?(selection)
          inducted = inductiones.new_model(selection.to_h)
          national_app3 = @national_apps[:app3]
          national_app4 = @national_apps[:app4]
          national_app3 = national_app3.find_national_local_id(selection.id)[0]
          national_app4 = national_app4.new_model(selection.to_h)

          national_app4.id_local = inducted.create
          national_app4.create
          national_app3.delete unless national_app3.nil?
          selection.delete unless selection.nil?
        end
      end

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      inductiones.find_all.each do |induction|
        if inductiones.business_rule_induction_to_local_crm?(induction)
          client = local_crms.new_model(induction.to_h)
          national_app4 = @national_apps[:app4]
          national_app5 = @national_apps[:app5]
          national_app4 = national_app4.find_national_local_id(induction.id)[0]
          national_app5 = national_app5.new_model(induction.to_h)

          begin
            national_app5.id_local = client.create
            national_app5.create
            national_app4.delete unless national_app4.nil?
            induction.delete unless induction.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.backtracce
            puts 'ERROR'
          end
        end
      end
    end
  end

  def lead_to_approach
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      puts(self.class.name + '.' + __method__.to_s + ' ~ ' + entity.to_s + ' - ' + Time.now.utc.to_s)
      leads = @local_apps_ids[entity][:app1]
      approach = @local_apps_ids[entity][:app2]
      abort('Wrong parameter for lead in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless leads.is_a?(YouthTalentDAO)
      abort('Wrong parameter for approach in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless approach.is_a?(YouthTalentDAO)

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      leads.find_all.each do |lead|
        if leads.business_rule_lead_to_approach?(lead)
          approached = approach.new_model(lead.to_h)
          national_app1 = @national_apps[:app1]
          national_app2 = @national_apps[:app2]
          national_app1 = national_app1.find_national_local_id(lead.id)[0]
          national_app2 = national_app2.new_model(lead.to_h)


          national_app2.id_local = approached.create
          national_app2.create
          national_app1.delete unless national_app1.nil?
          lead.delete unless lead.nil?
        end
      end
    end
  end

  def approach_to_rapproach
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      puts(self.class.name + '.' + __method__.to_s + ' ~ ' + entity.to_s + ' - ' + Time.now.utc.to_s)
      approach = @local_apps_ids[entity][:app2]
      rapproach = @local_apps_ids[entity][:app2_5]
      abort('Wrong parameter for approach in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless approach.is_a?(YouthTalentDAO)
      abort('Wrong parameter for rapproach in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless rapproach.is_a?(YouthTalentDAO)

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      approach.find_all.each do |approached|
        if approach.business_rule_approach_to_rapproach?(approached)
          rapproached = rapproach.new_model(approached.to_h)
          national_app2 = @national_apps[:app2]
          national_app2_5 = @national_apps[:app2_5]
          national_app2 = national_app2.find_national_local_id(approached.id)[0]
          national_app2_5 = national_app2_5.new_model(approached.to_h)

          rapproached.approaches_number = 1
          national_app2_5.id_local = rapproached.create
          national_app2_5.approaches_number = 1
          national_app2_5.create
          national_app2.delete unless national_app2.nil?
          approached.delete unless approached.nil?
        end
      end
    end
  end

  def stop_rapproach
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      puts(self.class.name + '.' + __method__.to_s + ' ~ ' + entity.to_s + ' - ' + Time.now.utc.to_s)
      rapproach = @local_apps_ids[entity][:app2_5]
      abort('Wrong parameter for rapproach in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless rapproach.is_a?(YouthTalentDAO)

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      rapproach.find_all.each do |rapproached|
        if rapproach.business_rule_stop_rapproach?(rapproached)
          national_app2_5 = @national_apps[:app2_5]
          national_app2_5 = national_app2_5.find_national_local_id(rapproached.id)[0]

          national_app2_5.delete unless national_app2_5.nil?
          rapproached.delete unless rapproached.nil?
        end
      end
    end
  end

  def rapproach_to_selection
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      puts(self.class.name + '.' + __method__.to_s + ' ~ ' + entity.to_s + ' - ' + Time.now.utc.to_s)
      rapproach = @local_apps_ids[entity][:app2_5]
      selection = @local_apps_ids[entity][:app3]
      abort('Wrong parameter for rapproach in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless rapproach.is_a?(YouthTalentDAO)
      abort('Wrong parameter for selection in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless selection.is_a?(YouthTalentDAO)

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      rapproach.find_all.each do |rapproached|
        if rapproach.business_rule_rapproach_to_selection?(rapproached)
          selected = selection.new_model(rapproached.to_h)
          national_app2_5 = @national_apps[:app2_5]
          national_app3 = @national_apps[:app3]
          national_app2_5 = national_app2_5.find_national_local_id(rapproached.id)[0]
          national_app3 = national_app3.new_model(rapproached.to_h)


          selected.responsable = rapproached.responsable_new_contact
          selected.first_approach_date = rapproached.next_contact_date
          national_app3.id_local = selected.create
          national_app3.responsable = rapproached.responsable_new_contact
          national_app3.first_approach_date = rapproached.next_contact_date
          national_app3.create
          national_app2_5.delete unless national_app2_5.nil?
          rapproached.delete unless rapproached.nil?
        end
      end
    end
  end

  def approach_to_selection
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      puts(self.class.name + '.' + __method__.to_s + ' ~ ' + entity.to_s + ' - ' + Time.now.utc.to_s)
      approach = @local_apps_ids[entity][:app2]
      selection = @local_apps_ids[entity][:app3]
      abort('Wrong parameter for approach in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless approach.is_a?(YouthTalentDAO)
      abort('Wrong parameter for selection in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless selection.is_a?(YouthTalentDAO)

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      approach.find_all.each do |approached|
        if approach.business_rule_approach_to_selection?(approached)
          selected = selection.new_model(approached.to_h)
          national_app2 = @national_apps[:app2]
          national_app3 = @national_apps[:app3]
          national_app2 = national_app2.find_national_local_id(approached.id)[0]
          national_app3 = national_app3.new_model(approached.to_h)

          national_app3.id_local = selected.create
          national_app3.create
          national_app2.delete unless national_app2.nil?
          approached.delete unless approached.nil?
        end
      end
    end
  end

  def selection_to_rapproach
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      puts(self.class.name + '.' + __method__.to_s + ' ~ ' + entity.to_s + ' - ' + Time.now.utc.to_s)
      selection = @local_apps_ids[entity][:app3]
      rapproach = @local_apps_ids[entity][:app2_5]
      abort('Wrong parameter for selection in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless selection.is_a?(YouthTalentDAO)
      abort('Wrong parameter for rapproach in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless rapproach.is_a?(YouthTalentDAO)

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      selection.find_all.each do |selected|
        if selection.business_rule_selection_to_rapproach?(selected)
          rapproached = rapproach.new_model(selected.to_h)
          national_app3 = @national_apps[:app3]
          national_app2_5 = @national_apps[:app2_5]
          national_app3 = national_app3.find_national_local_id(selected.id)[0]
          national_app2_5 = national_app2_5.new_model(selected.to_h)

          national_app2_5.id_local = rapproached.create
          national_app2_5.create
          national_app3.delete unless national_app3.nil?
          selected.delete unless selected.nil?
        end
      end
    end
  end

  def stop_selection
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      puts(self.class.name + '.' + __method__.to_s + ' ~ ' + entity.to_s + ' - ' + Time.now.utc.to_s)
      selection = @local_apps_ids[entity][:app3]
      abort('Wrong parameter for selection in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless selection.is_a?(YouthTalentDAO)

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      selection.find_all.each do |selected|
        if selection.business_rule_delete_selection?(selected)
          national_app3 = @national_apps[:app3]
          national_app3 = national_app3.find_national_local_id(selected.id)[0]

          national_app3.delete unless national_app3.nil?
          selected.delete unless selected.nil?
        end
      end
    end
  end

  def selection_to_induction
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      puts(self.class.name + '.' + __method__.to_s + ' ~ ' + entity.to_s + ' - ' + Time.now.utc.to_s)
      selection = @local_apps_ids[entity][:app3]
      induction = @local_apps_ids[entity][:app4]
      abort('Wrong parameter for selection in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless selection.is_a?(YouthTalentDAO)
      abort('Wrong parameter for induction in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless induction.is_a?(YouthTalentDAO)

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      selection.find_all.each do |selected|
        if selection.business_rule_selection_to_induction?(selected)
          inducted = induction.new_model(selected.to_h)
          national_app3 = @national_apps[:app3]
          national_app4 = @national_apps[:app4]
          national_app3 = national_app3.find_national_local_id(selected.id)[0]
          national_app4 = national_app4.new_model(selected.to_h)

          national_app4.id_local = inducted.create
          national_app4.create
          national_app3.delete unless national_app3.nil?
          selected.delete unless selected.nil?
        end
      end
    end
  end

  def induction_to_local_crm
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      puts(self.class.name + '.' + __method__.to_s + ' ~ ' + entity.to_s + ' - ' + Time.now.utc.to_s)
      induction = @local_apps_ids[entity][:app4]
      local_crm = @local_apps_ids[entity][:app5]
      abort('Wrong parameter for induction in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless induction.is_a?(YouthTalentDAO)
      abort('Wrong parameter for local_crm in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless local_crm.is_a?(YouthTalentDAO)

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      induction.find_all.each do |inducted|
        if induction.business_rule_induction_to_local_crm?(inducted)
          client = local_crm.new_model(inducted.to_h)
          national_app4 = @national_apps[:app4]
          national_app5 = @national_apps[:app5]
          national_app4 = national_app4.find_national_local_id(selected.id)[0]
          national_app5 = national_app5.new_model(selected.to_h)

          national_app5.id_local = client.create
          national_app5.create
          national_app4.delete unless national_app4.nil?
          inducted.delete unless inducted.nil?
        end
      end
    end
  end

end