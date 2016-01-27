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

    configORS(spaces,apps)
    configLocals(spaces, apps)
    configNational(spaces, apps)
    flow
    #TODO passagem de um CL para outro
  end

  # Detect and configure every ORS workspace and ORS app that is linked to tm
  # @todo research how to raise global variable ors_space_id
  # @todo research how to raise global variable ors_app
  # @param spaces [ControlDatabaseWorkspace] List of workspaces registered at the IM General
  # @param apps [ControlDatabaseApp] List of apps registered at the IM general
  def configORS(spaces, apps)
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)

    for i in 0...spaces.total_count
      if spaces.type(i) == $enum_type[:ors] && spaces.area(i) == $enum_area[:host]
        @ors_space_id = spaces.id(i)
        break
      end
    end

    for j in 0...apps.total_count
      work_id = apps.workspace_id_calculated(j)
      for i in 0...spaces.total_count
        if spaces.id(i) == work_id && spaces.type(i) == $enum_type[:ors] && spaces.area(i) == $enum_area[:host]
          @ors = HostDAO.new(apps.id(j))
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
      if spaces.type(i) == $enum_type[:local] && spaces.area(i) == $enum_area[:host]
        @local_spaces_ids[spaces.id(i)] = nil
      end
    end

    @entities = []
    for j in 0...apps.total_count
      work_id = apps.workspace_id_calculated(j)
      for i in 0...spaces.total_count
        if spaces.id(i) == work_id && !spaces.entity(i).nil? && spaces.area(i) == $enum_area[:host]
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

      for j in 0...apps.total_count
        work_id = apps.workspace_id_calculated(j)
        for i in 0...spaces.total_count
          if spaces.id(i) == work_id && !spaces.entity(i).nil? && spaces.entity(i).eql?(entity) && spaces.area(i) == $enum_area[:host]
            case apps.name(j)
              when $enum_host_apps_name[:leads] then app1 = HostDAO.new(apps.id(j))
              when $enum_host_apps_name[:approach] then app2 = HostDAO.new(apps.id(j))
              when $enum_host_apps_name[:reapproach] then app3 = HostDAO.new(apps.id(j))
              when $enum_host_apps_name[:alignment] then app4 = HostDAO.new(apps.id(j))
              when $enum_host_apps_name[:blacklist] then app5 = HostDAO.new(apps.id(j))
              when $enum_host_apps_name[:whitelist] then app6 = HostDAO.new(apps.id(j))
            end
          end
          @local_apps_ids[entity] = {:app1 => app1,
                                     :app2 => app2,
                                     :app3 => app3,
                                     :app4 => app4,
                                     :app5 => app5,
                                     :app6 => app6}

        end
      end
    end

  end

  def configNational(spaces, apps)
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)


    for i in 0...spaces.total_count
      if spaces.type(i) == $enum_type[:national] && spaces.area(i) == $enum_area[:host]
        @national_space_id = spaces.id(i)
        break
      end
    end

    for j in 0...apps.total_count
      work_id = apps.workspace_id_calculated(j)
      for i in 0...spaces.total_count
        if spaces.id(i) == work_id && spaces.type(i) == $enum_type[:national] && spaces.area(i) == $enum_area[:host]
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
    #local_to_national
  end

  # Migrate leads from the ORS app to all Local Leads Apps
  def ors_to_local
    puts(self.class.name + '.' + __method__.to_s + ' - ' + Time.now.utc.to_s)
    models_list = @ors.find_ors_to_local_lead
    models_list.each do |national_lead|
      sleep(3600) unless $podio_flag == true
      $podio_flag = true
      next unless @local_apps_ids.has_key?(national_lead.local_aiesec)
      local_leads = @local_apps_ids[national_lead.local_aiesec][:app1]

      abort('Wrong parameter for leads in ' + self.class.name + '.' + __method__.to_s) unless local_leads.is_a?(HostDAO)

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
      approach = @local_apps_ids[entity][:app2]
      reapproach = @local_apps_ids[entity][:app3]
      alignment = @local_apps_ids[entity][:app4]
      blacklist = @local_apps_ids[entity][:app5]
      whitelist = @local_apps_ids[entity][:app6]

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