require_relative '../control/control_database_workspace'
require_relative '../control/control_database_app'
require_relative 'app_ors_tm'
require_relative 'app1_inscritos'
require_relative 'app2_abordagem'
require_relative 'app3_dinamica'
require_relative 'app4_entrevista'
require_relative 'app5_membros'
require_relative 'app_nacional_tm'
require_relative '../enums'

# This class initializes, configure and take care of the TM module.
# The module is divided in 3 categories:
# * 1. ORS ( 1 x )
# * 2. Local ( Number of entities x )
# * 3. National ( 1 x )
class TM
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
      if spaces.type(i) == $enum_type[:ors] && spaces.area(i) == $enum_area[:tm]
        @ors_space_id = spaces.id(i)
        break
      end
    end

    limit = apps.total_count-1
    for i in 0..limit
      if apps.type(i) == $enum_type[:ors] && apps.area(i) == $enum_area[:tm]
        @ors_app = AppORSTM.new(apps.id(i))
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
            when $enum_apps_name[:app1] then app1 = App1Inscritos.new(apps.id(i))
            when $enum_apps_name[:app2] then app2 = App2Abordagem.new(apps.id(i))
            when $enum_apps_name[:app3] then app3 = App3Dinamica.new(apps.id(i))
            when $enum_apps_name[:app4] then app4 = App4Entrevista.new(apps.id(i))
            when $enum_apps_name[:app5] then app5 = App5Membros.new(apps.id(i))
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
      if apps.type(i) == $enum_type[:national] && spaces.area(i) == $enum_area[:tm]
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
      for i in 0..@ors_app.total_count-1
        if @ors_app.entidade_id(i) == entity
          inscrito = @local_apps_ids[entity][0]
          abort('Wrong parameter for spaces') unless inscrito.is_a?(App1Inscritos)

          inscrito.populate(@ors_app,i)
          inscrito.create
        end
      end
    end
  end

  # For all local apps, move the registers through customer flow.
  def local_to_local
    for entity in @entities do
      inscrito = @local_apps_ids[entity][0]
      abordado = @local_apps_ids[entity][1]
      dinamico = @local_apps_ids[entity][2]
      entrevistado = @local_apps_ids[entity][3]
      membro = @local_apps_ids[entity][4]

      abort('Wrong parameter for spaces') unless inscrito.is_a?(App1Inscritos)
      abort('Wrong parameter for spaces') unless abordado.is_a?(App2Abordagem)
      abort('Wrong parameter for spaces') unless dinamico.is_a?(App3Dinamica)
      abort('Wrong parameter for spaces') unless entrevistado.is_a?(App4Entrevista)
      abort('Wrong parameter for spaces') unless membro.is_a?(App5Membros)

      limit = inscrito.total_count
      for i in 0..limit-1
        if inscrito.is_abordado?(i)
          abordado.populate(inscrito,i)
          abordado.create
          inscrito.delete(i)
        end
      end
      
      limit = abordado.total_count
      for i in 0..limit-1
        if abordado.is_compareceu_dinamica?(i)
          dinamico.populate(abordado,i)
          dinamico.create
          abordado.delete(i)
        end
      end

      limit = dinamico.total_count
      for i in 0..limit-1
        if dinamico.is_entrevistado?(i)
          entrevistado.populate(dinamico,i)
          entrevistado.create
          dinamico.delete(i)
        end
      end

      limit = entrevistado.total_count
      for i in 0..limit-1
        if entrevistado.is_virou_membro?(i)
          membro.populate(entrevistado,i)
          membro.create
          entrevistado.delete(i)
        end
      end
    end
  end

  def local_to_national
  end

end
