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

  private

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
      if apps.type(i) == $enum_type[:national] && apps.area(i) == $enum_area[:tm]
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
      limit = @ors_app.total_count-1
      for i in 0..limit
        if @ors_app.entidade_id(i) == entity &&
        $enum_foi_transferido_ors[@ors_app.foi_transferido?(i)] != $enum_foi_transferido_ors[:sim]

          inscrito = @local_apps_ids[entity][0]
          abort('Wrong parameter for spaces') unless inscrito.is_a?(App1Inscritos)

          inscrito.populate(@ors_app,i)
          inscrito.create
          @ors_app.update_transferido(i)
        end
      end
    end
  end

  # For all local apps, move the registers through customer flow.
  def local_to_local
    inscrito_to_abordado
    abordado_to_dinamica
    dinamica_to_entrevista
    entrevista_to_membros
  end

  def inscrito_to_abordado
    for entity in @entities do
      inscrito = @local_apps_ids[entity][0]
      abordado = @local_apps_ids[entity][1]
      abort('Wrong parameter for spaces') unless inscrito.is_a?(App1Inscritos)
      abort('Wrong parameter for spaces') unless abordado.is_a?(App2Abordagem)

      limit = inscrito.total_count-1
      for i in 0..limit
        if $enum_abordado[inscrito.abordado(i)] == $enum_abordado[:sim]
          abordado.populate(inscrito,i)
          abordado.create
          inscrito.delete(i)
        end
        inscrito.refresh_item_list
        abordado.refresh_item_list
        @local_apps_ids[entity][0] = inscrito
        @local_apps_ids[entity][1] = abordado
      end
    end
  end

  def abordado_to_dinamica
    for entity in @entities do
      abordado = @local_apps_ids[entity][1]
      dinamica = @local_apps_ids[entity][2]
      abort('Wrong parameter for spaces') unless abordado.is_a?(App2Abordagem)
      abort('Wrong parameter for spaces') unless dinamica.is_a?(App3Dinamica)

      limit = abordado.total_count-1
      for i in 0..limit
        if $enum_dinamica_marcada[abordado.dinamica_marcada(i)] == $enum_dinamica_marcada[:sim] &&
        abordado.data_dinamica.nil? == false

          dinamica.populate(abordado,i)
          dinamica.create
          abordado.delete(i)
        end
        abordado.refresh_item_list
        dinamica.refresh_item_list
        @local_apps_ids[entity][1] = abordado
        @local_apps_ids[entity][2] = dinamica
      end
    end
  end

  def dinamica_to_entrevista
    for entity in @entities do
      dinamica = @local_apps_ids[entity][2]
      entrevista = @local_apps_ids[entity][3]
      abort('Wrong parameter for spaces') unless dinamica.is_a?(App3Dinamica)
      abort('Wrong parameter for spaces') unless entrevista.is_a?(App4Entrevista)

      limit = dinamica.total_count-1
      for i in 0..limit
        if $enum_aprovado_dinamica[dinamica.foi_aprovado(i)] == $enum_aprovado_dinamica[:sim] &&
        dinamica.data_entrevista.nil? == false
          entrevista.populate(dinamica,i)
          entrevista.create
          dinamica.delete(i)
        end
      end
      dinamica.refresh_item_list
      entrevista.refresh_item_list
      @local_apps_ids[entity][2] = dinamica
      @local_apps_ids[entity][3] = entrevista
    end
  end

  def entrevista_to_membros
    for entity in @entities do
      entrevista = @local_apps_ids[entity][3]
      membro = @local_apps_ids[entity][4]
      abort('Wrong parameter for spaces') unless entrevista.is_a?(App4Entrevista)
      abort('Wrong parameter for spaces') unless membro.is_a?(App5Membros)

      limit = entrevista.total_count-1
      for i in 0..limit
        if $enum_resultado_entrevista[entrevista.resultado_entrevista(i)] == $enum_resultado_entrevista[:aprovado]
          membro.populate(entrevista,i)
          membro.create
          entrevista.delete(i)
        end
      end
    end
    entrevista.refresh_item_list
    membro.refresh_item_list
    @local_apps_ids[entity][3] = entrevista
    @local_apps_ids[entity][4] = membro
  end

  def local_to_national
  end

end
