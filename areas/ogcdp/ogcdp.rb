require_relative '../../control/control_database_workspace'
require_relative '../../control/control_database_app'
require_relative 'global_citizen_dao'

# This class initializes, configure and take care of the oGCDP module.
# The module is divided in 3 categories:
# * 1. ORS ( 1 x )
# * 2. Local ( Number of entities x )
# * 3. National ( 1 x )
class OGX_GCDP
  # @param spaces [ControlDatabaseWorkspace] List of workspaces registered at the IM General
  # @param apps [ControlDatabaseApp] List of apps registered at the IM General
  def initialize(podioDatabase)
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)

    spaces = podioDatabase.workspaces
    apps = podioDatabase.apps
    log = podioDatabase.logs
    config(spaces,apps)
    flow
    #TODO passagem de um CL para outro
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
          spaces.area(i) == $enum_area[:ogcdp]
        @entities1 << spaces.entity(i)
        @local_apps_ids1[spaces.entity(i)] = {:empty => ''}
      end
      if !spaces.entity(i).nil? &&
          !spaces.id2(i).nil? &&
          spaces.type(i) == $enum_type[:local] &&
          spaces.area(i) == $enum_area[:ogcdp]
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

        if spaces.id(i) == work_id &&
            spaces.type(i) == $enum_type[:ors] &&
            spaces.area(i) == $enum_area[:ogcdp]
          @ors = GlobalCitizenDAO.new(apps.id(j))

        elsif !entity.nil? &&
              spaces.id(i) == work_id &&
              spaces.type(i) == $enum_type[:local] &&
              spaces.area(i) == $enum_area[:ogcdp]
          case apps.name(j)
            when $enum_oGCDP_apps_name[:leads] then @local_apps_ids1[entity].merge!({:app1 => GlobalCitizenDAO.new(apps.id(j))})
            when $enum_oGCDP_apps_name[:contacteds] then @local_apps_ids1[entity].merge!({:app2 => GlobalCitizenDAO.new(apps.id(j))})
            when $enum_oGCDP_apps_name[:epi] then @local_apps_ids1[entity].merge!({:app3 => GlobalCitizenDAO.new(apps.id(j))})
            when $enum_oGCDP_apps_name[:open] then @local_apps_ids1[entity].merge!({:app4 => GlobalCitizenDAO.new(apps.id(j))})
            when $enum_oGCDP_apps_name[:ip] then @local_apps_ids1[entity].merge!({:app5 => GlobalCitizenDAO.new(apps.id(j))})
            when $enum_oGCDP_apps_name[:ma] then @local_apps_ids1[entity].merge!({:app6 => GlobalCitizenDAO.new(apps.id(j))})
            when $enum_oGCDP_apps_name[:re] then @local_apps_ids1[entity].merge!({:app7 => GlobalCitizenDAO.new(apps.id(j))})
            when $enum_oGCDP_apps_name[:co] then @local_apps_ids1[entity].merge!({:app8 => GlobalCitizenDAO.new(apps.id(j))})
          end

        elsif !entity.nil? &&
              spaces.id2(i) == work_id &&
              spaces.type(i) == $enum_type[:local] &&
              spaces.area(i) == $enum_area[:ogcdp]
          case apps.name(j)
            when $enum_oGCDP_apps_name[:leads] then @local_apps_ids2[entity].merge!({:app1 => GlobalCitizenDAO.new(apps.id(j))})
            when $enum_oGCDP_apps_name[:contacteds] then @local_apps_ids2[entity].merge!({:app2 => GlobalCitizenDAO.new(apps.id(j))})
            when $enum_oGCDP_apps_name[:epi] then @local_apps_ids2[entity].merge!({:app3 => GlobalCitizenDAO.new(apps.id(j))})
            when $enum_oGCDP_apps_name[:open] then @local_apps_ids2[entity].merge!({:app4 => GlobalCitizenDAO.new(apps.id(j))})
            when $enum_oGCDP_apps_name[:ip] then @local_apps_ids2[entity].merge!({:app5 => GlobalCitizenDAO.new(apps.id(j))})
            when $enum_oGCDP_apps_name[:ma] then @local_apps_ids2[entity].merge!({:app6 => GlobalCitizenDAO.new(apps.id(j))})
            when $enum_oGCDP_apps_name[:re] then @local_apps_ids2[entity].merge!({:app7 => GlobalCitizenDAO.new(apps.id(j))})
            when $enum_oGCDP_apps_name[:co] then @local_apps_ids2[entity].merge!({:app8 => GlobalCitizenDAO.new(apps.id(j))})
          end

        elsif spaces.id(i) == work_id &&
              spaces.type(i) == $enum_type[:national] &&
              spaces.area(i) == $enum_area[:ogcdp]
          case apps.name(j)
            when $enum_oGCDP_apps_name[:leads] then @national_apps[:app1] = GlobalCitizenDAO.new(apps.id(j))
            when $enum_oGCDP_apps_name[:contacteds] then @national_apps[:app2] = GlobalCitizenDAO.new(apps.id(j))
            when $enum_oGCDP_apps_name[:epi] then @national_apps[:app3] = GlobalCitizenDAO.new(apps.id(j))
            when $enum_oGCDP_apps_name[:open] then @national_apps[:app4] = GlobalCitizenDAO.new(apps.id(j))
            when $enum_oGCDP_apps_name[:ip] then @national_apps[:app5] = GlobalCitizenDAO.new(apps.id(j))
            when $enum_oGCDP_apps_name[:ma] then @national_apps[:app6] = GlobalCitizenDAO.new(apps.id(j))
            when $enum_oGCDP_apps_name[:re] then @national_apps[:app7] = GlobalCitizenDAO.new(apps.id(j))
            when $enum_oGCDP_apps_name[:co] then @national_apps[:app8] = GlobalCitizenDAO.new(apps.id(j))
          end
        end
      end
    end
  end

  def flow
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    ors_to_local
    local_to_local2
    local_to_local
  end

  # Migrate leads from the ORS app to all Local Leads Apps
  def ors_to_local
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    models_list = @ors.find_ors_to_local_lead
    models_list.each do |national_ors|
      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      next unless @local_apps_ids1.has_key?(national_ors.local_aiesec_ogcdp_ogip)
      local_leads = @local_apps_ids1[national_ors.local_aiesec_ogcdp_ogip][:app1]
      abort('Wrong parameter for leads in ' + self.class.name + '.' + __method__.to_s) unless local_leads.is_a?(GlobalCitizenDAO)
      puts(self.class.name + '.' + __method__.to_s + ' ~ ' + national_ors.local_aiesec_ogcdp_ogip.to_s + ' - ' + Time.now.utc.to_s)

      local_leads2 = nil
      local_leads2 = @local_apps_ids2[national_ors.local_aiesec_ogcdp_ogip][:app1] unless !@local_apps_ids2.has_key?(national_ors.local_aiesec_ogcdp_ogip)

      local_lead = local_leads.new_model(national_ors.to_h)
      local_lead.lead_date = {'start' => Time.new.strftime('%Y-%m-%d %H:%M:%S')}

      if local_leads2.is_a?(GlobalCitizenDAO)
        local_lead2 = local_leads2.new_model(national_ors.to_h)
        local_lead2.lead_date = {'start' => Time.new.strftime('%Y-%m-%d %H:%M:%S')}
      end

      national_ors.sync_with_local = 2
      national_app1 = @national_apps[:app1].new_model(national_ors.to_h)
      national_app1.lead_date = {'start' => Time.new.strftime('%Y-%m-%d %H:%M:%S')}

      begin
        national_app1.id_local_1 = national_ors.id_local_1 = local_lead.create
        national_app1.id_local_2 = national_ors.id_local_2 = local_lead2.create if local_leads2.is_a?(GlobalCitizenDAO)

        national_ors.update
        national_app1.create
      rescue => exception
        puts 'ERROR'
        puts exception.to_s
        puts 'ERROR'
      end
    end
  end

  # For all local apps, move the registers through customer flow.
  def local_to_local
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities1 do
      puts(self.class.name + '.' + __method__.to_s + ' ~ ' + entity.to_s + ' - ' + Time.now.utc.to_s)
      leads = @local_apps_ids1[entity][:app1]
      contacteds = @local_apps_ids1[entity][:app2]
      epis = @local_apps_ids1[entity][:app3]
      opens = @local_apps_ids1[entity][:app4]
      in_progress = @local_apps_ids1[entity][:app5]
      matchs = @local_apps_ids1[entity][:app6]
      realizes = @local_apps_ids1[entity][:app7]
      completes = @local_apps_ids1[entity][:app8]

      abort('Wrong parameter for leads in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless leads.is_a?(GlobalCitizenDAO)
      abort('Wrong parameter for contacteds in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless contacteds.is_a?(GlobalCitizenDAO)
      abort('Wrong parameter for epis in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless epis.is_a?(GlobalCitizenDAO)
      abort('Wrong parameter for opens in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless opens.is_a?(GlobalCitizenDAO)
      abort('Wrong parameter for in_progress in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless in_progress.is_a?(GlobalCitizenDAO)
      abort('Wrong parameter for matchs in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless matchs.is_a?(GlobalCitizenDAO)
      abort('Wrong parameter for realizes in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless realizes.is_a?(GlobalCitizenDAO)
      abort('Wrong parameter for completes in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless completes.is_a?(GlobalCitizenDAO)

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      leads.find_all.each do |lead|
        if leads.can_be_contacted?(lead)
          original = @ors.find_national_local_id_1(lead.id)[0]
          next unless lead.methods.include?(:duplicate_vp)
          case lead.duplicate_vp
            when 1 then
              next unless !@local_apps_ids2.has_key?(entity)
              (Podio::Item.delete(original.id_local_2) unless original.id_local_2.nil?) unless original.nil?
              original.id_local_2 = nil unless original.nil?
              contacted = contacteds.new_model(lead.to_h)
              national_app1 = @national_apps[:app1]
              national_app1 = national_app1.find_national_local_id_1(lead.id)[0]
              national_app2 = @national_apps[:app2]
              national_app2 = national_app2.new_model(lead.to_h)


              begin
                original.update unless original.nil?
                national_app2.id_local_1 = contacted.create
                national_app2.create
                national_app1.delete unless national_app1.nil?
                lead.delete unless lead.nil?
              rescue => exception
                puts 'ERROR'
                puts exception.to_s
                puts 'ERROR'
              end
            when 2 then
              (Podio::Item.delete(original.id_local_2) unless original.id_local_2.nil?) unless original.nil?
              original.id_local_2 = nil unless original.nil?
              contacted = contacteds.new_model(lead.to_h)
              national_app1 = @national_apps[:app1]
              national_app1 = national_app1.find_national_local_id_1(lead.id)[0]
              national_app2 = @national_apps[:app2]
              national_app2 = national_app2.new_model(lead.to_h)

              begin
                original.update unless original.nil?
                national_app2.id_local_1 = contacted.create
                national_app2.create
                national_app1.delete unless national_app1.nil?
                lead.delete unless lead.nil?
              rescue => exception
                puts 'ERROR'
                puts exception.to_s
                puts 'ERROR'
              end
            when 3 then
              (Podio::Item.delete(original.id_local_2) unless original.id_local_2.nil?) unless original.nil?
              original.id_local_2 = nil unless original.nil?
              contacted = contacteds.new_model(lead.to_h)
              national_app1 = @national_apps[:app1]
              national_app1 = national_app1.find_national_local_id_1(lead.id)[0]
              national_app2 = @national_apps[:app2]
              national_app2 = national_app2.new_model(lead.to_h)

              begin
                original.update unless original.nil?
                national_app2.id_local_1 = contacted.create
                national_app2.create
                national_app1.delete unless national_app1.nil?
                lead.delete unless lead.nil?
              rescue => exception
                puts 'ERROR'
                puts exception.to_s
                puts 'ERROR'
              end
            when 4 then
              begin
                ((lead.delete unless lead.nil?) unless !original.id_local_2.nil?) unless original.nil?
                original.id_local_1 = nil unless original.nil?
                original.update unless original.nil?
              rescue => exception
                puts 'ERROR'
                puts exception.to_s
                puts 'ERROR'
              end
            else nil
          end
        end
      end

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      contacteds.find_all.each do |contacted|
        if contacteds.can_be_EPI?(contacted)
          epi = epis.new_model(contacted.to_h)
          national_app2 = @national_apps[:app2]
          national_app2 = national_app2.find_national_local_id_1(contacted.id)[0]
          national_app3 = @national_apps[:app3]
          national_app3 = national_app3.new_model(contacted.to_h)

          begin
            national_app3.id_local_1 = epi.create
            national_app3.create
            national_app2.delete unless national_app2.nil?
            contacted.delete unless contacted.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.to_s
            puts 'ERROR'
          end
        end
      end

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      epis.find_all.each do |epi|
        if epis.can_be_open?(epi)
          open = opens.new_model(epi.to_h)
          national_app3 = @national_apps[:app3]
          national_app3 = national_app3.find_national_local_id_1(epi.id)[0]
          national_app4 = @national_apps[:app4]
          national_app4 = national_app4.new_model(epi.to_h)

          begin
            national_app4.id_local_1 = open.create
            national_app4.create
            national_app3.delete unless national_app3.nil?
            epi.delete unless epi.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.to_s
            puts 'ERROR'
          end
        end
      end

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      opens.find_all.each do |open|
        if opens.can_be_ip?(open)
          open.applying = nil
          ip = in_progress.new_model(open.to_h)
          national_app4 = @national_apps[:app4]
          national_app4 = national_app4.find_national_local_id_1(open.id)[0]
          national_app5 = @national_apps[:app5]
          national_app5 = national_app5.new_model(open.to_h)

          begin
            national_app5.id_local_1 = ip.create
            national_app5.create
            national_app4.delete unless national_app4.nil?
            open.delete unless open.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.to_s
            puts 'ERROR'
          end
        end
      end

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      in_progress.find_all.each do |ip|
        if in_progress.can_be_ma?(ip)
          ma = matchs.new_model(ip.to_h)
          national_app5 = @national_apps[:app5]
          national_app5 = national_app5.find_national_local_id_1(ip.id)[0]
          national_app6 = @national_apps[:app6]
          national_app6 = national_app6.new_model(ip.to_h)

          begin
            national_app6.id_local_1 = ma.create
            national_app6.create
            national_app5.delete unless national_app5.nil?
            ip.delete unless ip.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.to_s
            puts 'ERROR'
          end
        end
      end

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      matchs.find_all.each do |ma|
        if matchs.can_be_re?(ma)
          re = realizes.new_model(ma.to_h)
          national_app6 = @national_apps[:app6]
          national_app6 = national_app6.find_national_local_id_1(ma.id)[0]
          national_app7 = @national_apps[:app7]
          national_app7 = national_app7.new_model(ma.to_h)

          begin
            national_app7.id_local_1 = re.create
            national_app7.create
            national_app6.delete unless national_app6.nil?
            ma.delete unless ma.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.to_s
            puts 'ERROR'
          end
        end
      end

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      realizes.find_all.each do |re|
        if realizes.can_be_co?(re)
          co = completes.new_model(re.to_h)
          national_app7 = @national_apps[:app7]
          national_app7 = national_app7.find_national_local_id_1(re.id)[0]
          national_app8 = @national_apps[:app8]
          national_app8 = national_app8.new_model(re.to_h)

          begin
            national_app8.id_local_1 = co.create
            national_app8.create
            national_app7.delete unless national_app7.nil?
            re.delete unless re.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.to_s
            puts 'ERROR'
          end
        end
      end

    end
  end

  # For all local apps, move the registers through customer flow.
  def local_to_local2
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities2 do
      puts(self.class.name + '.' + __method__.to_s + ' ~ ' + entity.to_s + ' - ' + Time.now.utc.to_s)
      leads = @local_apps_ids2[entity][:app1]
      contacteds = @local_apps_ids2[entity][:app2]
      epis = @local_apps_ids2[entity][:app3]
      opens = @local_apps_ids2[entity][:app4]
      in_progress = @local_apps_ids2[entity][:app5]
      matchs = @local_apps_ids2[entity][:app6]
      realizes = @local_apps_ids2[entity][:app7]
      completes = @local_apps_ids2[entity][:app8]

      abort('Wrong parameter for leads in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless leads.is_a?(GlobalCitizenDAO)
      abort('Wrong parameter for contacteds in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless contacteds.is_a?(GlobalCitizenDAO)
      abort('Wrong parameter for epis in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless epis.is_a?(GlobalCitizenDAO)
      abort('Wrong parameter for opens in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless opens.is_a?(GlobalCitizenDAO)
      abort('Wrong parameter for in_progress in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless in_progress.is_a?(GlobalCitizenDAO)
      abort('Wrong parameter for matchs in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless matchs.is_a?(GlobalCitizenDAO)
      abort('Wrong parameter for realizes in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless realizes.is_a?(GlobalCitizenDAO)
      abort('Wrong parameter for completes in ' + self.class.name + '.' + __method__.to_s + ' at entity ' + entity.to_s) unless completes.is_a?(GlobalCitizenDAO)

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      leads.find_all.each do |lead|
        if leads.can_be_contacted?(lead)
          original = @ors.find_national_local_id_2(lead.id)[0]
          next unless lead.methods.include?(:duplicate_vp)
          case lead.duplicate_vp
            when 2, 4 then
              begin
                ((lead.delete unless lead.nil?) unless !original.id_local_1.nil?) unless original.nil?
                original.id_local_2 = nil unless original.nil?
                original.update unless original.nil?
              rescue => exception
                puts 'ERROR'
                puts exception.to_s
                puts 'ERROR'
              end
            when 3 then
              (Podio::Item.delete(original.id_local_1) unless original.id_local_1.nil?) unless original.nil?
              original.id_local_1 = nil unless original.nil?
              contacted = contacteds.new_model(lead.to_h)
              national_app1 = @national_apps[:app1]
              national_app1 = national_app1.find_national_local_id_2(lead.id)[0]
              national_app2 = @national_apps[:app2]
              national_app2 = national_app2.new_model(lead.to_h)

              begin
                original.update unless original.nil?
                national_app2.id_local_2 = contacted.create
                national_app2.create
                national_app1.delete unless national_app1.nil?
                lead.delete unless lead.nil?
              rescue => exception
                puts 'ERROR'
                puts exception.to_s
                puts 'ERROR'
              end
            else nil
          end
        end
      end

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      contacteds.find_all.each do |contacted|
        if contacteds.can_be_EPI?(contacted)
          epi = epis.new_model(contacted.to_h)
          national_app2 = @national_apps[:app2]
          national_app2 = national_app2.find_national_local_id_2(contacted.id)[0]
          national_app3 = @national_apps[:app3]
          national_app3 = national_app3.new_model(contacted.to_h)

          begin
            national_app3.id_local_2 = epi.create
            national_app3.create
            national_app2.delete unless national_app2.nil?
            contacted.delete unless contacted.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.to_s
            puts 'ERROR'
          end
        end
      end

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      epis.find_all.each do |epi|
        if epis.can_be_open?(epi)
          open = opens.new_model(epi.to_h)
          national_app3 = @national_apps[:app3]
          national_app3 = national_app3.find_national_local_id_2(epi.id)[0]
          national_app4 = @national_apps[:app4]
          national_app4 = national_app4.new_model(epi.to_h)

          begin
            national_app4.id_local_2 = open.create
            national_app4.create
            national_app3.delete unless national_app3.nil?
            epi.delete unless epi.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.to_s
            puts 'ERROR'
          end
        end
      end

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      opens.find_all.each do |open|
        if opens.can_be_ip?(open)
          open.applying = nil
          ip = in_progress.new_model(open.to_h)
          national_app4 = @national_apps[:app4]
          national_app4 = national_app4.find_national_local_id_2(open.id)[0]
          national_app5 = @national_apps[:app5]
          national_app5 = national_app5.new_model(open.to_h)

          begin
            national_app5.id_local_2 = ip.create
            national_app5.create
            national_app4.delete unless national_app4.nil?
            open.delete unless open.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.to_s
            puts 'ERROR'
          end
        end
      end

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      in_progress.find_all.each do |ip|
        if in_progress.can_be_ma?(ip)
          ma = matchs.new_model(ip.to_h)
          national_app5 = @national_apps[:app5]
          national_app5 = national_app5.find_national_local_id_2(ip.id)[0]
          national_app6 = @national_apps[:app6]
          national_app6 = national_app6.new_model(ip.to_h)

          begin
            national_app6.id_local_2 = ma.create
            national_app6.create
            national_app5.delete unless national_app5.nil?
            ip.delete unless ip.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.to_s
            puts 'ERROR'
          end
        end
      end

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      matchs.find_all.each do |ma|
        if matchs.can_be_re?(ma)
          re = realizes.new_model(ma.to_h)
          national_app6 = @national_apps[:app6]
          national_app6 = national_app6.find_national_local_id_2(ma.id)[0]
          national_app7 = @national_apps[:app7]
          national_app7 = national_app7.new_model(ma.to_h)

          begin
            national_app7.id_local_2 = re.create
            national_app7.create
            national_app6.delete unless national_app6.nil?
            ma.delete unless ma.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.to_s
            puts 'ERROR'
          end
        end
      end

      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      realizes.find_all.each do |re|
        if realizes.can_be_co?(re)
          co = completes.new_model(re.to_h)
          national_app7 = @national_apps[:app7]
          national_app7 = national_app7.find_national_local_id_2(re.id)[0]
          national_app8 = @national_apps[:app8]
          national_app8 = national_app8.new_model(re.to_h)

          begin
            national_app8.id_local_2 = co.create
            national_app8.create
            national_app7.delete unless national_app7.nil?
            re.delete unless re.nil?
          rescue => exception
            puts 'ERROR'
            puts exception.to_s
            puts 'ERROR'
          end
        end
      end

    end
  end
end
