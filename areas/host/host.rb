require_relative '../../control/control_database_workspace'
require_relative '../../control/control_database_app'
require_relative 'host_dao'

# This class initializes, configure and take care of the tm module.
# The module is divided in 3 categories:
# * 1. ORS ( 1 x )
# * 2. Local ( Number of entities x )
# * 3. National ( 1 x )
class HOST
  # @param spaces [ControlDatabaseWorkspace] List of workspaces registered at the IM General
  # @param apps [ControlDatabaseApp] List of apps registered at the IM General
  def initialize(spaces, apps)
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    abort('Wrong parameter for spaces in ' + self.class.name + '.' + __method__.to_s) unless spaces.is_a?(ControlDatabaseWorkspace)
    abort('Wrong parameter for apps in ' + self.class.name + '.' + __method__.to_s) unless apps.is_a?(ControlDatabaseApp)

    config(spaces,apps)
    flow
    #TODO passagem de um CL para outro
  end

  def config(spaces,app)
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    @local_apps_ids1 = {}
    @local_apps_ids2 = {}
    @local_apps_ids3 = {}
    @local_apps_ids4 = {}
    @national_apps = {}

    @entities1 = []
    @entities2 = []
    @entities3 = []
    @entities4 = []
    for i in 0...spaces.total_count
      if !spaces.entity(i).nil? &&
          !spaces.id(i).nil? &&
          spaces.type(i) == $enum_type[:local] &&
          spaces.area(i) == $enum_area[:host]
        @entities1 << spaces.entity(i)
        @local_apps_ids1[spaces.entity(i)] = {:empty => ''}
      end
      if !spaces.entity(i).nil? &&
          !spaces.id2(i).nil? &&
          spaces.type(i) == $enum_type[:local] &&
          spaces.area(i) == $enum_area[:host]
        @entities2 << spaces.entity(i)
        @local_apps_ids2[spaces.entity(i)] = {:empty => ''}
      end
      if !spaces.entity(i).nil? &&
          !spaces.id3(i).nil? &&
          spaces.type(i) == $enum_type[:local] &&
          spaces.area(i) == $enum_area[:host]
        @entities3 << spaces.entity(i)
        @local_apps_ids3[spaces.entity(i)] = {:empty => ''}
      end
      if !spaces.entity(i).nil? &&
          !spaces.id4(i).nil? &&
          spaces.type(i) == $enum_type[:local] &&
          spaces.area(i) == $enum_area[:host]
        @entities4 << spaces.entity(i)
        @local_apps_ids4[spaces.entity(i)] = {:empty => ''}
      end
    end
    @entities1.uniq!
    @entities2.uniq!
    @entities3.uniq!
    @entities4.uniq!

    for j in 0...apps.total_count
      work_id = apps.workspace_id_calculated(j) || apps.workspace_id2_calculated(j) || apps.workspace_id3_calculated(j) || apps.workspace_id4_calculated(j)
      for i in 0...spaces.total_count
        next unless !work_id.nil? && (!spaces.id(i).nil? || !spaces.id2(i).nil?)
        entity = spaces.entity(i)

        if spaces.id(i) == work_id &&
            spaces.type(i) == $enum_type[:ors] &&
            spaces.area(i) == $enum_area[:host]
          @ors = HostDAO.new(apps.id(j))

        elsif !entity.nil? &&
              spaces.id(i) == work_id &&
              spaces.type(i) == $enum_type[:local] &&
              spaces.area(i) == $enum_area[:host]
          case apps.name(j)
            when $enum_HOST_apps_name[:leads] then @local_apps_ids1[entity].merge!({:app1 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:approach] then @local_apps_ids1[entity].merge!({:app2 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:reapproach] then @local_apps_ids1[entity].merge!({:app2_5 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:alignment] then @local_apps_ids1[entity].merge!({:app3 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:blacklist] then @local_apps_ids1[entity].merge!({:app4 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:whitelist] then @local_apps_ids1[entity].merge!({:app5 => HostDAO.new(apps.id(j))})
          end

        elsif !entity.nil? &&
            spaces.id2(i) == work_id &&
            spaces.type(i) == $enum_type[:local] &&
            spaces.area(i) == $enum_area[:host]
          case apps.name(j)
            when $enum_HOST_apps_name[:leads] then @local_apps_ids2[entity].merge!({:app1 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:approach] then @local_apps_ids2[entity].merge!({:app2 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:reapproach] then @local_apps_ids2[entity].merge!({:app2_5 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:alignment] then @local_apps_ids2[entity].merge!({:app3 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:blacklist] then @local_apps_ids2[entity].merge!({:app4 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:whitelist] then @local_apps_ids2[entity].merge!({:app5 => HostDAO.new(apps.id(j))})
          end

        elsif !entity.nil? &&
            spaces.id3(i) == work_id &&
            spaces.type(i) == $enum_type[:local] &&
            spaces.area(i) == $enum_area[:host]
          case apps.name(j)
            when $enum_HOST_apps_name[:leads] then @local_apps_ids3[entity].merge!({:app1 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:approach] then @local_apps_ids3[entity].merge!({:app2 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:reapproach] then @local_apps_ids3[entity].merge!({:app2_5 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:alignment] then @local_apps_ids3[entity].merge!({:app3 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:blacklist] then @local_apps_ids3[entity].merge!({:app4 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:whitelist] then @local_apps_ids3[entity].merge!({:app5 => HostDAO.new(apps.id(j))})
          end

        elsif !entity.nil? &&
            spaces.id4(i) == work_id &&
            spaces.type(i) == $enum_type[:local] &&
            spaces.area(i) == $enum_area[:host]
          case apps.name(j)
            when $enum_HOST_apps_name[:leads] then @local_apps_ids4[entity].merge!({:app1 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:approach] then @local_apps_ids4[entity].merge!({:app2 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:reapproach] then @local_apps_ids4[entity].merge!({:app2_5 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:alignment] then @local_apps_ids4[entity].merge!({:app3 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:blacklist] then @local_apps_ids4[entity].merge!({:app4 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:whitelist] then @local_apps_ids4[entity].merge!({:app5 => HostDAO.new(apps.id(j))})
          end

        elsif spaces.id(i) == work_id &&
              spaces.type(i) == $enum_type[:national] &&
              spaces.area(i) == $enum_area[:host]
          case apps.name(j)
            when $enum_HOST_apps_name[:leads] then @national_apps[entity].merge!({:app1 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:approach] then @national_apps[entity].merge!({:app2 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:reapproach] then @national_apps[entity].merge!({:app2_5 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:alignment] then @national_apps[entity].merge!({:app3 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:blacklist] then @national_apps[entity].merge!({:app4 => HostDAO.new(apps.id(j))})
            when $enum_HOST_apps_name[:whitelist] then @national_apps[entity].merge!({:app5 => HostDAO.new(apps.id(j))})
          end
        end
      end
    end
  end

  def flow
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    ors_to_local
    for i in 1...4 do
      local_to_local(i)
    end
  end

  # Migrate leads from the ORS app to all Local Leads Apps
  def ors_to_local
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    models_list = @ors.find_ors_to_local_lead
    models_list.each do |national_ors|
      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      next unless @local_apps_ids1.has_key?(national_ors.local_aiesec)
      local_leads = @local_apps_ids1[national_ors.local_aiesec][:app1]
      abort('Wrong parameter for leads in ' + self.class.name + '.' + __method__.to_s) unless local_leads.is_a?(HostDAO)
      puts(self.class.name + '.' + __method__.to_s + ' ~ ' + national_ors.local_aiesec.to_s + ' - ' + Time.now.utc.to_s)

      local_leads4 = local_leads3 = local_leads2 = nil
      local_leads2 = @local_apps_ids2[national_ors.local_aiesec][:app1] unless !@local_apps_ids2.has_key?(national_ors.local_aiesec)
      local_leads3 = @local_apps_ids2[national_ors.local_aiesec][:app1] unless !@local_apps_ids3.has_key?(national_ors.local_aiesec)
      local_leads4 = @local_apps_ids2[national_ors.local_aiesec][:app1] unless !@local_apps_ids4.has_key?(national_ors.local_aiesec)

      local_lead = local_leads.new_model(national_ors.to_h)
      local_lead.lead_date = {'start' => Time.new.strftime('%Y-%m-%d %H:%M:%S')}

      if local_leads2.is_a?(HostDAO)
        local_lead2 = local_leads2.new_model(national_ors.to_h)
        local_lead2.lead_date = {'start' => Time.new.strftime('%Y-%m-%d %H:%M:%S')}
      end
      if local_leads3.is_a?(HostDAO)
        local_lead3 = local_leads3.new_model(national_ors.to_h)
        local_lead3.lead_date = {'start' => Time.new.strftime('%Y-%m-%d %H:%M:%S')}
      end
      if local_leads4.is_a?(HostDAO)
        local_lead4 = local_leads4.new_model(national_ors.to_h)
        local_lead4.lead_date = {'start' => Time.new.strftime('%Y-%m-%d %H:%M:%S')}
      end

      national_ors.sync_with_local = 2
      national_app1 = @national_apps[:app1].new_model(national_ors.to_h)
      national_app1.lead_date = {'start' => Time.new.strftime('%Y-%m-%d %H:%M:%S')}

      begin
        national_app1.id_local_1 = national_ors.id_local_1 = local_lead.create
        national_app1.id_local_2 = national_ors.id_local_2 = local_lead.create if local_leads2.is_a?(HostDAO)
        national_app1.id_local_3 = national_ors.id_local_3 = local_lead.create if local_leads3.is_a?(HostDAO)
        national_app1.id_local_4 = national_ors.id_local_4 = local_lead.create if local_leads4.is_a?(HostDAO)

        national_ors.update
        national_app1.create
      rescue => exception
        puts 'ERROR'
        puts exception.backtracce
        puts 'ERROR'
      end
    end
  end

  # For all local apps, move the registers through customer flow.
  def local_to_local(iteration)
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entities in @entities1.zip(@entities2).zip(@entities3).zip(@entities4) do
      next if entities[iteration].nil?
      entity = entities[iteration]
      
      leads = @local_apps_ids1[entity][:app1]
      approach = @local_apps_ids1[entity][:app2]
      reapproach = @local_apps_ids1[entity][:app3]
      alignment = @local_apps_ids1[entity][:app4]
      blacklist = @local_apps_ids1[entity][:app5]
      whitelist = @local_apps_ids1[entity][:app6]

      abort('Wrong parameter for leads in ' + self.class.name + '.' + __method__.to_s) unless leads.is_a?(HostDAO)
      abort('Wrong parameter for approach in ' + self.class.name + '.' + __method__.to_s) unless approach.is_a?(HostDAO)
      abort('Wrong parameter for reapproach in ' + self.class.name + '.' + __method__.to_s) unless reapproach.is_a?(HostDAO)
      abort('Wrong parameter for alignment in ' + self.class.name + '.' + __method__.to_s) unless alignment.is_a?(HostDAO)
      abort('Wrong parameter for blacklist in ' + self.class.name + '.' + __method__.to_s) unless blacklist.is_a?(HostDAO)
      abort('Wrong parameter for whitelist in ' + self.class.name + '.' + __method__.to_s) unless whitelist.is_a?(HostDAO)

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      leads.find_all.each do |lead|
        if leads.go_to_approach?(lead)
          approached = approach.new_model(lead.to_h)
          approached.create
          lead.delete
        end
      end

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      approach.find_all.each do |approached|
        if approach.go_to_reapproach?(approached)
          reapproached = reapproach.new_model(approached.to_h)
          reapproached.create
          approached.delete
        elsif approach.go_to_alignment?(approached)
          aligned = alignment.new_model(approached.to_h)
          aligned.create
          approached.delete
        end
      end

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      alignment.find_all.each do |aligned|
        if alignment.return_to_reapproach?(aligned)
          reapproached = reapproach.new_model(aligned.to_h)
          reapproached.create
          aligned.delete
        elsif alignment.go_to_whitelist?(aligned)
          good_case = whitelist.new_model(aligned.to_h)
          good_case.create
          aligned.delete
        elsif alignment.go_to_blacklist?(aligned)
          bad_case = blacklist.new_model(aligned.to_h)
          bad_case.create
          aligned.delete
        end
      end

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      reapproach.find_all.each do |reapproached|
        if reapproach.finally_go_to_alignment?(reapproached)
          aligned = alignment.new_model(reapproached.to_h)
          aligned.create
          reapproached.delete
        end
      end
    end
  end

  def local_to_national
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
  end
end