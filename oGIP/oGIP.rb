require_relative '../control/control_database_workspace'
require_relative '../control/control_database_app'
require_relative 'global_talent'
require_relative '../enums'

# This class initializes, configure and take care of the TM module.
# The module is divided in 3 categories:
# * 1. ORS ( 1 x )
# * 2. Local ( Number of entities x )
# * 3. National ( 1 x )
class OGX_GIP
  # @param spaces [ControlDatabaseWorkspace] List of workspaces registered at the IM General
  # @param apps [ControlDatabaseApp] List of apps registered at the IM General
  def initialize(spaces, apps)
    abort('Wrong parameter for spaces') unless spaces.is_a?(ControlDatabaseWorkspace)
    abort('Wrong parameter for apps') unless apps.is_a?(ControlDatabaseApp)

    configORS(spaces,apps)
    configLocals(spaces, apps)
    configNational(spaces, apps)
    flow
  end

  # Detect and configure every ORS workspace and ORS app that is linked to TM
  # @todo research how to raise global variable ors_space_id
  # @todo research how to raise global variable ors_app
  # @param spaces [ControlDatabaseWorkspace] List of workspaces registered at the IM General
  # @param apps [ControlDatabaseApp] List of apps registered at the IM general
  def configORS(spaces, apps)
    limit = spaces.total_count-1
    for i in 0..limit
      if spaces.type(i) == $enum_type[:ors] && spaces.area(i) == $enum_area[:ogip]
        @ors_space_id = spaces.id(i)
        break
      end
    end

    limit = apps.total_count-1
    for i in 0..limit
      if apps.type(i) == $enum_type[:ors] && apps.area(i) == $enum_area[:ogip]
        @ors_app = GlobalTalent.new(apps.id(i))
        break
      end
    end
  end

  # Detect and configure every Locals workspaces and Locals apps taht are linkted to TM
  # @todo research how to raise global array local_spaces_ids
  # @todo research how to raise global hash local_apps_ids
  # @param spaces [ControlDatabaseWorkspace] List of workspaces registered at the IM General
  # @param apps [ControlDatabaseApp] List of apps registered at the IM general
  def configLocals(spaces, apps)
    @local_spaces_ids = []
    @local_apps_ids = {}

    limit = spaces.total_count - 1
    for i in 0..limit
      if spaces.type(i) == $enum_type[:local] && spaces.area(i) == $enum_area[:ogip]
        @local_spaces_ids << spaces.id(i)
      end
    end

    @entities = []
    limit = apps.total_count - 1
    for i in 0..limit
      if !apps.entity(i).nil? && apps.area(i) == $enum_area[:ogip]
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
        if !apps.entity(i).nil? && apps.entity(i).eql?(entity) && apps.area(i) == $enum_area[:ogip]
          case apps.name(i)
            when $enum_oGIP_apps_name[:leads] then app1 = GlobalTalent.new(apps.id(i))
            when $enum_oGIP_apps_name[:contacteds] then app2 = GlobalTalent.new(apps.id(i))
            when $enum_oGIP_apps_name[:epi] then app3 = GlobalTalent.new(apps.id(i))
            when $enum_oGIP_apps_name[:open] then app4 = GlobalTalent.new(apps.id(i))
            when $enum_oGIP_apps_name[:ip] then app5 = GlobalTalent.new(apps.id(i))
            when $enum_oGIP_apps_name[:ma] then app6 = GlobalTalent.new(apps.id(i))
            when $enum_oGIP_apps_name[:re] then app7 = GlobalTalent.new(apps.id(i))
          end
        end
      end
      @local_apps_ids[entity] = [app1,app2,app3,app4,app5,app6,app7]
    end

  end

  def configNational(spaces, apps)
    limit = spaces.total_count - 1
    (0..limit).each do |i|
      if spaces.type(i) == $enum_type[:national] && spaces.area(i) == $enum_area[:ogip]
        @national_space_id = spaces.id(i)
        break
      end
    end

    limit = apps.total_count - 1
    (0..limit).each do |i|
      if apps.type(i) == $enum_type[:national] && apps.area(i) == $enum_area[:ogip]
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
    limit = @ors_app.total_count - 1
    for entity in @entities do
      (0..limit).each do |i|
        if @ors_app.local_aiesec_id(i) == entity
          leads = @local_apps_ids[entity][0]
          abort('Wrong parameter for leads') unless leads.is_a?(GlobalTalent)

          leads.populate(@ors_app,i)
          leads.create
          @ors_app.delete(i)
        end
      end
    end
  end

  # For all local apps, move the registers through customer flow.
  def local_to_local
    for entity in @entities do
      leads = @local_apps_ids[entity][0]
      contacteds = @local_apps_ids[entity][1]
      epis = @local_apps_ids[entity][2]
      opens = @local_apps_ids[entity][3]
      in_progress = @local_apps_ids[entity][4]
      matchs = @local_apps_ids[entity][5]
      realizes = @local_apps_ids[entity][6]

      abort('Wrong parameter for leads') unless leads.is_a?(GlobalTalent)
      abort('Wrong parameter for contacteds') unless contacteds.is_a?(GlobalTalent)
      abort('Wrong parameter for epis') unless epis.is_a?(GlobalTalent)
      abort('Wrong parameter for opens') unless opens.is_a?(GlobalTalent)
      abort('Wrong parameter for in_progress') unless in_progress.is_a?(GlobalTalent)
      abort('Wrong parameter for matchs') unless matchs.is_a?(GlobalTalent)
      abort('Wrong parameter for realizes') unless realizes.is_a?(GlobalTalent)

      limit = leads.total_count - 1
      (0..limit).each do |i|
        if test_lead_to_contacted(leads,i)
          contacteds.populate(leads,i)
          contacteds.create
          leads.delete(i)
        end
      end
      
      limit = contacteds.total_count - 1
      (0..limit).each do |i|
        if test_contacted_to_EPI(contacteds,i)
          epis.populate(contacteds,i)
          epis.create
          contacteds.delete(i)
        end
      end

      limit = epis.total_count - 1
      (0..limit).each do |i|
        if test_EPI_to_open(epis,i)
          opens.populate(epis,i)
          opens.create
          epis.delete(i)
        end
      end

      limit = opens.total_count - 1
      (0..limit).each do |i|
        if test_open_to_ip(opens,i)
          in_progress.populate(opens,i)
          in_progress.applying = nil
          in_progress.create
          opens.delete(i)
        end
      end

      limit = in_progress.total_count - 1
      (0..limit).each do |i|
        if test_ip_to_ma(in_progress,i)
          matchs.populate(in_progress,i)
          matchs.create
          in_progress.delete(i)
        end
      end

      limit = matchs.total_count - 1
      (0..limit).each do |i|
        if test_ma_to_re(matchs,i)
          realizes.populate(matchs,i)
          realizes.create
          matchs.delete(i)
        end
      end
    end
  end

  def local_to_national
  end

  def test_ORS_to_Local(youth_leader,i)
    true
  end

  def test_lead_to_contacted(youth_leader,i)
    true unless youth_leader.first_contact_date(i).nil? or youth_leader.first_contact_responsable_id(i).nil?
  end

  def test_contacted_to_EPI(youth_leader,i)
    true unless youth_leader.epi_date(i).nil? or youth_leader.epi_responsable_id(i).nil?
  end

  def test_EPI_to_open(youth_leader,i)
    true unless youth_leader.link_to_expa(i).nil? or youth_leader.ep_manager_id(i).nil?
  end

  def test_open_to_ip(youth_leader,i)
    youth_leader.applying?(i)
  end

  def test_ip_to_ma(youth_leader,i)
    true unless youth_leader.match_date(i).nil?
  end

  def test_ma_to_re(youth_leader,i)
    true unless youth_leader.ops_date(i).nil? or youth_leader.realize_date(i).nil?
  end
end
