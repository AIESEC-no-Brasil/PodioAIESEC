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
    puts @ors_app.total_count
    ors_to_local
    local_to_local
    #local_to_national
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
          inscrito.set_phones(@ors_app.phones(i))
          inscrito.set_telefone(@ors_app.telefone(i))
          inscrito.set_celular(@ors_app.celular(i))
          inscrito.set_operadora(@ors_app.operadora(i))
          inscrito.set_emails(@ors_app.emails(i))
          inscrito.set_email_text(@ors_app.email_text(i))
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
          inscrito.set_conheceu_aiesec(@ors_app.conheceu_aiesec(i))
          inscrito.set_pessoa_que_indicou(@ors_app.pessoa_que_indicou(i))
          inscrito.set_voluntario_ferias(@ors_app.voluntario_ferias?(i))
          inscrito.set_projeto_especifico(@ors_app.projeto_especifico(i))
          inscrito.create
        end
      end
    end
  end

  def local_to_local
    for entity in @entities do
      inscrito = @local_apps_ids[entity][0]
      abordado = @local_apps_ids[entity][1]

      abort('Wrong parameter for spaces') unless inscrito.is_a?(App1Inscritos)
      abort('Wrong parameter for spaces') unless abordado.is_a?(App2Abordagem)

      for i in 0..inscrito.total_count-1
          puts i
          puts inscrito.email_text(i)
          puts inscrito.telefone(i)
          puts inscrito.abordado?(i)
          puts
        if inscrito.abordado?(i)
          puts i
          abordado.set_nome_completo(inscrito.nome_completo(i))
          abordado.set_sexo(inscrito.sexo(i))
          abordado.set_data_nascimento(inscrito.data_nascimento(i))
          abordado.set_phones(inscrito.phones(i))
          abordado.set_telefone(inscrito.telefone(i))
          abordado.set_celular(inscrito.celular(i))
          abordado.set_operadora(inscrito.operadora(i))
          abordado.set_emails(inscrito.emails(i))
          abordado.set_email_text(inscrito.email_text(i))
          abordado.set_endereco(inscrito.endereco(i))
          abordado.set_cep(inscrito.cep(i))
          abordado.set_cidade(inscrito.cidade(i))
          abordado.set_estado_id(inscrito.estado_id(i))
          abordado.set_formacao(inscrito.formacao(i))
          abordado.set_curso(inscrito.curso(i))
          abordado.set_semestre(inscrito.semestre(i))
          abordado.set_faculdade(inscrito.faculdade(i))
          abordado.set_ingles(inscrito.ingles(i))
          abordado.set_espanhol(inscrito.espanhol(i))
          abordado.set_entidade(inscrito.entidade_id(i))
          abordado.set_turno(inscrito.turno(i))
          abordado.set_programa_interesse(inscrito.programa_interesse(i))
          abordado.set_conheceu_aiesec(inscrito.conheceu_aiesec(i))
          abordado.set_pessoa_que_indicou(inscrito.pessoa_que_indicou(i))
          abordado.set_voluntario_ferias(inscrito.voluntario_ferias?(i))
          abordado.set_projeto_especifico(inscrito.projeto_especifico(i))
          abordado.create
        end
      end
    end
  end

  def local_to_national
  end

end
