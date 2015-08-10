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

class TM
  def initialize(spaces, apps)
    abort('Wrong parameter for spaces') unless spaces.is_a?(ControlDatabaseWorkspace)
    abort('Wrong parameter for apps') unless apps.is_a?(ControlDatabaseApp)

    configORS(spaces,apps)
    configLocals(spaces, apps)
    configNational(spaces, apps)
    flow
  end

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
    local_to_national
  end

  def ors_to_local
    for entity in @entities do
      for i in 0..@ors_app.total_count-1
        if @ors_app.entidade_id(i) == entity
          inscrito = @local_apps_ids[entity][0]
          abort('Wrong parameter for spaces') unless inscrito.is_a?(App1Inscritos)

          inscrito.set_nome_completo(@ors_app.nome_completo(i))
          inscrito.set_sexo(@ors_app.sexo(i))
          inscrito.set_data_nascimento(@ors_app.data_nascimento(i))
          inscrito.set_telefone(@ors_app.telefone(i))
          inscrito.set_celular(@ors_app.celular(i))
          inscrito.set_operadora(@ors_app.operadora(i))
          inscrito.set_email(@ors_app.email(i))
          inscrito.set_endereco(@ors_app.endereco(i))
          inscrito.set_cep(@ors_app.cep(i))
          inscrito.set_cidade(@ors_app.cidade(i))
          inscrito.set_estado_id(@ors_app.estado_id(i))
          inscrito.set_formacao(@ors_app.formacao(i))
          inscrito.set_curso(@ors_app.curso(i))
          inscrito.set_semestre(@ors_app.semestre(i))
          inscrito.set_faculdade(@ors_app.faculdade(i))
          inscrito.set_ingles(@ors_app.ingles(i))
          inscrito.set_espanhol(@ors_app.espanhol(i))
          inscrito.set_entidade(@ors_app.entidade_id(i))
          inscrito.set_turno(@ors_app.turno(i))
          inscrito.set_programa_interesse(@ors_app.programa_interesse(i))
          inscrito.set_voluntario_ferias(@ors_app.voluntario_ferias?(i))
          inscrito.set_projeto_especifico(@ors_app.projeto_especifico(i))
          inscrito.create
        end
      end
    end
  end

  def local_to_local
  end

  def local_to_national
  end

end