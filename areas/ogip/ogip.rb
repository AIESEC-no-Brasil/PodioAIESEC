require_relative '../../control/control_database_workspace'
require_relative '../../control/control_database_app'
require_relative 'global_talent_dao'

# This class initializes, configure and take care of the tm module.
# The module is divided in 3 categories:
# * 1. ORS ( 1 x )
# * 2. Local ( Number of entities x )
# * 3. National ( 1 x )
class OGX_GIP
  # @param spaces [ControlDatabaseWorkspace] List of workspaces registered at the IM General
  # @param apps [ControlDatabaseApp] List of apps registered at the IM General
  def initialize(spaces, apps)
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    abort('Wrong parameter for spaces in ' + self.class.name + '.' + __method__.to_s) unless spaces.is_a?(ControlDatabaseWorkspace)
    abort('Wrong parameter for apps in ' + self.class.name + '.' + __method__.to_s) unless apps.is_a?(ControlDatabaseApp)

    configORS(spaces,apps)
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
      if spaces.type(i) == $enum_type[:ors] && spaces.area(i) == $enum_area[:ogip]
        @ors_space_id = spaces.id(i)
        break
      end
    end

    for j in 0...apps.total_count
      work_id = apps.workspace_id_calculated(j)
      for i in 0...spaces.total_count
        if spaces.id(i) == work_id && spaces.type(i) == $enum_type[:ors] && spaces.area(i) == $enum_area[:ogip]
          @ors = GlobalTalentDAO.new(apps.id(j))
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
    @local_apps_ids = {}

    for i in 0...spaces.total_count
      if spaces.type(i) == $enum_type[:local] && spaces.area(i) == $enum_area[:ogip]
        @local_spaces_ids[spaces.id(i)] = nil
      end
    end

    @entities = []
    for j in 0...apps.total_count
      work_id = apps.workspace_id_calculated(j)
      for i in 0...spaces.total_count
        if spaces.id(i) == work_id && !spaces.entity(i).nil? && spaces.area(i) == $enum_area[:ogip]
          @entities << spaces.entity(i)
        end
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
      app7 = nil
      app8 = nil
      cards = nil

      for j in 0...apps.total_count
        work_id = apps.workspace_id_calculated(j)
        for i in 0...spaces.total_count
          if spaces.id(i) == work_id && !spaces.entity(i).nil? && spaces.entity(i).eql?(entity) && spaces.area(i) == $enum_area[:ogip]
            case apps.name(j)
              when $enum_oGIP_apps_name[:leads] then app1 = GlobalTalentDAO.new(apps.id(j))
              when $enum_oGIP_apps_name[:contacteds] then app2 = GlobalTalentDAO.new(apps.id(j))
              when $enum_oGIP_apps_name[:epi] then app3 = GlobalTalentDAO.new(apps.id(j))
              when $enum_oGIP_apps_name[:open] then app4 = GlobalTalentDAO.new(apps.id(j))
              when $enum_oGIP_apps_name[:ip] then app5 = GlobalTalentDAO.new(apps.id(j))
              when $enum_oGIP_apps_name[:ma] then app6 = GlobalTalentDAO.new(apps.id(j))
              when $enum_oGIP_apps_name[:re] then app7 = GlobalTalentDAO.new(apps.id(j))
              when $enum_oGIP_apps_name[:co] then app8 = GlobalTalentDAO.new(apps.id(j))
              when $enum_oGIP_apps_name[:cards] then cards = GlobalTalentDAO.new(apps.id(j))
            end
          end
          @local_apps_ids[entity] = {:app1 => app1,
                                     :app2 => app2,
                                     :app3 => app3,
                                     :app4 => app4,
                                     :app5 => app5,
                                     :app6 => app6,
                                     :app7 => app7,
                                     :app8 => app8,
                                     :cards => cards}

        end
      end
    end

  end

  def configNational(spaces, apps)
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)

    for i in 0...spaces.total_count
      if spaces.type(i) == $enum_type[:national] && spaces.area(i) == $enum_area[:ogip]
        @national_space_id = spaces.id(i)
        break
      end
    end

    for j in 0...apps.total_count
      work_id = apps.workspace_id_calculated(j)
      for i in 0...spaces.total_count
        if spaces.id(i) == work_id && spaces.type(i) == $enum_type[:national] && spaces.area(i) == $enum_area[:ogip]
          @national_app_id = apps.id(j)
          break
        end
      end
    end
  end

  def flow
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    ors_to_local
    local_to_local
    local_to_national
  end

  # Migrate leads from the ORS app to all Local Leads Apps
  def ors_to_local
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    models_list = @ors.find_ors_to_local_lead
    models_list.each do |national_lead|
      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      next unless not @local_apps_ids.has_key?(national_lead.local_aiesec)
      local_leads = @local_apps_ids[national_lead.local_aiesec][:app1]

      abort('Wrong parameter for leads in ' + self.class.name + '.' + __method__.to_s) unless local_leads.is_a?(GlobalTalentDAO)

      local_lead = local_leads.new_model(national_lead.to_h)
      local_lead.create
      national_lead.sync_with_local = 2
      national_lead.update
    end
  end

  # For all local apps, move the registers through customer flow.
  def local_to_local
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    for entity in @entities do
      leads = @local_apps_ids[entity][:app1]
      contacteds = @local_apps_ids[entity][:app2]
      epis = @local_apps_ids[entity][:app3]
      opens = @local_apps_ids[entity][:app4]
      in_progress = @local_apps_ids[entity][:app5]
      matchs = @local_apps_ids[entity][:app6]
      realizes = @local_apps_ids[entity][:app7]
      completes = @local_apps_ids[entity][:app8]
      cards = @local_apps_ids[entity][:cards]

      abort('Wrong parameter for leads in ' + self.class.name + '.' + __method__.to_s) unless leads.is_a?(GlobalTalentDAO)
      abort('Wrong parameter for contacteds in ' + self.class.name + '.' + __method__.to_s) unless contacteds.is_a?(GlobalTalentDAO)
      abort('Wrong parameter for epis in ' + self.class.name + '.' + __method__.to_s) unless epis.is_a?(GlobalTalentDAO)
      abort('Wrong parameter for opens in ' + self.class.name + '.' + __method__.to_s) unless opens.is_a?(GlobalTalentDAO)
      abort('Wrong parameter for in_progress in ' + self.class.name + '.' + __method__.to_s) unless in_progress.is_a?(GlobalTalentDAO)
      abort('Wrong parameter for matchs in ' + self.class.name + '.' + __method__.to_s) unless matchs.is_a?(GlobalTalentDAO)
      abort('Wrong parameter for realizes in ' + self.class.name + '.' + __method__.to_s) unless realizes.is_a?(GlobalTalentDAO)
      abort('Wrong parameter for completes in ' + self.class.name + '.' + __method__.to_s) unless completes.is_a?(GlobalTalentDAO)

      leads.find_all.each do |lead|
        sleep(3600) unless $podio_flag == true
        $podio_flag = true
        if leads.can_be_contacted?(lead)
          contacted = contacteds.new_model(lead.to_h)
          contacted.create
          lead.delete
        end
      end
      
      contacteds.find_all.each do |contacted|
        sleep(3600) unless $podio_flag == true
        $podio_flag = true
        if contacteds.can_be_EPI?(contacted)
          epi = epis.new_model(contacted.to_h)
          epi.create
          contacted.delete
        end
      end

      epis.find_all.each do |epi|
        sleep(3600) unless $podio_flag == true
        $podio_flag = true
        if epis.can_be_open?(epi)
          open = opens.new_model(epi.to_h)
          open.create
          epi.delete
        end
      end

      opens.find_all.each do |open|
        sleep(3600) unless $podio_flag == true
        $podio_flag = true
        if opens.can_be_ip?(open)
          open.applying = nil
          ip = in_progress.new_model(open.to_h)
          ip.create
          open.delete
        end
      end

      in_progress.find_all.each do |ip|
        sleep(3600) unless $podio_flag == true
        $podio_flag = true
        if in_progress.can_be_ma?(ip)
          ma = matchs.new_model(ip.to_h)
          ma.create
          ip.delete
        end
      end

      matchs.find_all.each do |ma|
        sleep(3600) unless $podio_flag == true
        $podio_flag = true
        if matchs.can_be_re?(ma)
          re = realizes.new_model(ma.to_h)
          re.create
          ma.delete
        end
      end

      realizes.find_all.each do |re|
        sleep(3600) unless $podio_flag == true
        $podio_flag = true
        if realizes.can_be_re?(re)
          co = completes.new_model(re.to_h)
          co.create
          re.delete
        end
      end

    end
  end

  def local_to_national
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
  end
end
