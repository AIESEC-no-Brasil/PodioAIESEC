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
    puts 'configORS'
    limit = spaces.total_count-1
    for i in 0..limit
      if spaces.type(i) == $enum_type[:ors] && spaces.area(i) == $enum_area[:ogcdp]
        @ors_space_id = spaces.id(i)
        break
      end
    end

    limit = apps.total_count-1
    for i in 0..limit
      if apps.type(i) == $enum_type[:ors] && apps.area(i) == $enum_area[:ogcdp]
        @ors = GlobalCitizenDAO.new(apps.id(i))
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

    limit = spaces.total_count - 1
    for i in 0..limit
      if spaces.type(i) == $enum_type[:local] && spaces.area(i) == $enum_area[:ogcdp]
        @local_spaces_ids << spaces.id(i)
      end
    end

    @entities = []
    limit = apps.total_count - 1
    for i in 0..limit
      if !apps.entity(i).nil? && apps.area(i) == $enum_area[:ogcdp]
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
      app6 = nil
      app7 = nil
      for i in 0..apps.total_count - 1
        if !apps.entity(i).nil? && apps.entity(i).eql?(entity) && apps.area(i) == $enum_area[:igdcp]
          case apps.name(i)
            when $enum_oGCDP_apps_name[:leads] then app1 = HostDAO.new(apps.id(i))
            when $enum_oGCDP_apps_name[:approach] then app2 = HostDAO.new(apps.id(i))
            when $enum_oGCDP_apps_name[:reapproach] then app3 = HostDAO.new(apps.id(i))
            when $enum_oGCDP_apps_name[:alignment] then app4 = HostDAO.new(apps.id(i))
            when $enum_oGCDP_apps_name[:blacklist] then app5 = HostDAO.new(apps.id(i))
            when $enum_oGCDP_apps_name[:whitelist] then app6 = HostDAO.new(apps.id(i))
          end
        end
      end
      @local_apps_ids[entity] = [app1,app2,app3,app4,app5,app6,app7]
    end

  end

  def configNational(spaces, apps)
    limit = spaces.total_count - 1
    (0..limit).each do |i|
      if spaces.type(i) == $enum_type[:national] && spaces.area(i) == $enum_area[:ogcdp]
        @national_space_id = spaces.id(i)
        break
      end
    end

    limit = apps.total_count - 1
    (0..limit).each do |i|
      if apps.type(i) == $enum_type[:national] && apps.area(i) == $enum_area[:ogcdp]
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
    puts 'ors_to_local'
    models_list = @ors.find_ors_to_local_lead
    models_list.each do |national_lead|
      local_leads = @local_apps_ids[national_lead.local_aiesec][0]

      abort('Wrong parameter for leads in ' + self.class.name + '.' + __method__.to_s) unless local_leads.is_a?(HostDAO)

      local_lead = local_leads.new_model(national_lead.to_h)
      local_lead.create
      national_lead.sync_with_local = 2
      national_lead.update
    end
  end

  # For all local apps, move the registers through customer flow.
  def local_to_local
    for entity in @entities do
      leads = @local_apps_ids[entity][0]
      approach = @local_apps_ids[entity][1]
      reapproach = @local_apps_ids[entity][2]
      alignment = @local_apps_ids[entity][3]
      blacklist = @local_apps_ids[entity][4]
      whitelist = @local_apps_ids[entity][5]

      abort('Wrong parameter for leads in ' + self.class.name + '.' + __method__.to_s) unless leads.is_a?(HostDAO)
      abort('Wrong parameter for approach in ' + self.class.name + '.' + __method__.to_s) unless approach.is_a?(HostDAO)
      abort('Wrong parameter for reapproach in ' + self.class.name + '.' + __method__.to_s) unless reapproach.is_a?(HostDAO)
      abort('Wrong parameter for alignment in ' + self.class.name + '.' + __method__.to_s) unless alignment.is_a?(HostDAO)
      abort('Wrong parameter for blacklist in ' + self.class.name + '.' + __method__.to_s) unless blacklist.is_a?(HostDAO)
      abort('Wrong parameter for whitelist in ' + self.class.name + '.' + __method__.to_s) unless whitelist.is_a?(HostDAO)

      leads.find_all.each do |lead|
        if leads.go_to_approach?(lead)
          approached = approach.new_model(lead.to_h)
          approached.create
          lead.delete
        end
      end
      
      approach.find_all.each do |approached|
        if approach.go_to_reapproach?(approached)
          reapproached = reapproach.new_model(approached.to_h)
          reapproached.create
          approached.delete
        elsif approached.go_to_alignment?(approached)
          aligned = alignment.new_model(approached.to_h)
          aligned.create
          approached.delete
        end
      end

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
  end
end
