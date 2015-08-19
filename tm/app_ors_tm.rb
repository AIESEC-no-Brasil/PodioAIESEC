require_relative '../control/podio_app_control'
require_relative '../enums'

class AppORSTM < PodioAppControl

  def initialize(app_id)
    super(app_id)
    @fields = {:nome => 'nome',
               :sexo => 'sexo',
               :data_nascimento => 'data-de-nascimento-2',
               :telefone => 'telefone-2',
               :telefone_old => 'telefone-3',
               :celular => 'celular-2',
               :operadora => 'operadora-test',
               :email => 'email',
               :email_old => 'email-2',
               :endereco => 'endereco2',
               :cep => 'cep',
               :cidade => 'cidade',
               :estado => 'estado2',
               :formacao => 'formacao2',
               :curso => 'curso',
               :semestre => 'semestre-2',
               :faculdade => 'faculdade',
               :ingles => 'nivel-de-ingles',
               :espanhol => 'nivel-de-espanhol',
               :entidade => 'aiesec-mais-proxima2',
               :turno => 'melhor-turno-test',
               :programa_interesse => 'programa-de-interesse2',
               :como_conheceu_aiesec => 'como-conheceu-a-aiesec',
               :pessoa_que_indicou => 'nome-da-pessoaentidade-que-lhe-indicou',
               :voluntario_ferias => 'voce-esta-se-inscrevendo-para-o-programa-de-trabalho-vo',
               :vaga_especifica => 'caso-voce-esta-se-candidatando-a-algum-projetovaga-espe'}
  end

  def nome_completo(index)
    i = get_field_index_by_external_id(index, @fields[:nome])
    fields(index, i).to_s unless i.nil?
  end

  def sexo(index)
    i = get_field_index_by_external_id(index, @fields[:sexo])
    $enum_sexo.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def data_nascimento(index)
    i = get_field_index_by_external_id(index, @fields[:data_nascimento])
    DateTime.strptime(@item[0][0][:fields][i]['values'][0]['start_date'] + ' 00:00:00','%Y-%m-%d %H:%M:%S') unless i.nil?
  end

  def phones(index)
    i = get_field_index_by_external_id(index, @fields[:telefone])
    values(index, i) unless i.nil?
  end

  def telefone(index)
    i = get_field_index_by_external_id(index, @fields[:telefone_old])
    fields(index, i).to_s.gsub(/[^0-9]/,'') unless i.nil?
  end

  def celular(index)
    i = get_field_index_by_external_id(index, @fields[:celular])
    fields(index, i).to_s.gsub(/[^0-9]/,'') unless i.nil?
  end

  def operadora(index)
    i = get_field_index_by_external_id(index, @fields[:operadora])
    $enum_operadora.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def emails(index)
    i = get_field_index_by_external_id(index, @fields[:email])
    values(index, i) unless i.nil?
  end

  def email_text(index)
    i = get_field_index_by_external_id(index, @fields[:email_old])
    fields(index, i).to_s unless i.nil?
  end

  def endereco(index)
    i = get_field_index_by_external_id(index, @fields[:endereco])
    fields(index, i).to_s unless i.nil?
  end

  def cep(index)
    i = get_field_index_by_external_id(index, @fields[:cep])
    fields(index, i).to_s unless i.nil?
  end

  def cidade(index)
    i = get_field_index_by_external_id(index, @fields[:cidade])
    fields(index, i).to_s unless i.nil?
  end

  def estado_id(index)
    i = get_field_index_by_external_id(index, @fields[:estado])
    fields(index, i)['item_id'].to_i unless i.nil?
  end

  def formacao(index)
    i = get_field_index_by_external_id(index, @fields[:formacao])
    $enum_formacao.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def curso(index)
    i = get_field_index_by_external_id(index, @fields[:curso])
    fields(index, i).to_s unless i.nil?
  end

  def semestre(index)
    i = get_field_index_by_external_id(index, @fields[:semestre])
    $enum_semestre.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def faculdade(index)
    i = get_field_index_by_external_id(index, @fields[:faculdade])
    fields(index, i).to_s unless i.nil?
  end

  def ingles(index)
    i = get_field_index_by_external_id(index, @fields[:ingles])
    $enum_lingua.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def espanhol(index)
    i = get_field_index_by_external_id(index, @fields[:espanhol])
    $enum_lingua.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def entidade_id(index)
    i = get_field_index_by_external_id(index, @fields[:entidade])
    fields(index, i)['item_id'].to_i unless i.nil?
  end

  def turno(index)
    i = get_field_index_by_external_id(index, @fields[:turno])
    $enum_turno.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def programa_interesse(index)
    i = get_field_index_by_external_id(index, @fields[:programa_interesse])
    $enum_programa.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def conheceu_aiesec(index)
    i = get_field_index_by_external_id(index, @fields[:como_conheceu_aiesec])
    $enum_conheceu.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def pessoa_que_indicou(index)
    i = get_field_index_by_external_id(index, @fields[:pessoa_que_indicou])
    fields(index, i).to_s unless i.nil?
  end

  def voluntario_ferias(index)
    i = get_field_index_by_external_id(index, @fields[:voluntario_ferias])
    $enum_inscricao_especifica.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def projeto_especifico(index)
    i = get_field_index_by_external_id(index, @fields[:vaga_especifica])
    fields(index, i).to_s unless i.nil?
  end
end