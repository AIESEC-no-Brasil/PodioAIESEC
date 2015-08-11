require_relative '../control/podio_app_control'
require_relative '../enums'

class AppORSTM < PodioAppControl
  def initialize(app_id)
    super(app_id)
    @fields = {:nome => 'nome',
               :sexo => 'sexo',
               :data_nascimento => 'data-de-nascimento-2',
               :telefone => 'telefone',
               :celular => 'celular',
               :operadora => 'operadora-test',
               :email => 'text',
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
    i = get_external_id_index(index, @fields[:nome])
    fields(index, i).to_s unless i.nil?
  end

  def sexo(index)
    i = get_external_id_index(index, @fields[:sexo])
    $enum_sexo.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def data_nascimento(index)
    i = get_external_id_index(index, @fields[:data_nascimento])
    DateTime.strptime(@item[0][0][:fields][i]['values'][0]['start_date'] + ' 00:00:00','%Y-%m-%d %H:%M:%S') unless i.nil?
  end

  def telefone(index)
    i = get_external_id_index(index, @fields[:telefone])
    fields(index, i).to_s.gsub!(/[^0-9]/,'') unless i.nil?
  end

  def celular(index)
    i = get_external_id_index(index, @fields[:celular])
    fields(index, i).to_s.gsub!(/[^0-9]/,'') unless i.nil?
  end

  def operadora(index)
    i = get_external_id_index(index, @fields[:operadora])
    $enum_operadora.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def email(index)
    i = get_external_id_index(index, @fields[:email])
    fields(index, i).to_s unless i.nil?
  end

  def endereco(index)
    i = get_external_id_index(index, @fields[:endereco])
    fields(index, i).to_s unless i.nil?
  end

  def cep(index)
    i = get_external_id_index(index, @fields[:cep])
    fields(index, i).to_s unless i.nil?
  end

  def cidade(index)
    i = get_external_id_index(index, @fields[:cidade])
    fields(index, i).to_s unless i.nil?
  end

  def estado_id(index)
    i = get_external_id_index(index, @fields[:estado])
    fields(index, i)['item_id'].to_i unless i.nil?
  end

  def formacao(index)
    i = get_external_id_index(index, @fields[:formacao])
    $enum_formacao.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def curso(index)
    i = get_external_id_index(index, @fields[:curso])
    fields(index, i).to_s unless i.nil?
  end

  def semestre(index)
    i = get_external_id_index(index, @fields[:semestre])
    $enum_semestre.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def faculdade(index)
    i = get_external_id_index(index, @fields[:faculdade])
    fields(index, i).to_s unless i.nil?
  end

  def ingles(index)
    i = get_external_id_index(index, @fields[:ingles])
    $enum_lingua.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def espanhol(index)
    i = get_external_id_index(index, @fields[:espanhol])
    $enum_lingua.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def entidade_id(index)
    i = get_external_id_index(index, @fields[:entidade])
    fields(index, i)['item_id'].to_i unless i.nil?
  end

  def turno(index)
    i = get_external_id_index(index, @fields[:turno])
    $enum_turno.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def programa_interesse(index)
    i = get_external_id_index(index, @fields[:programa_interesse])
    $enum_programa.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def conheceu_aiesec(index)
    i = get_external_id_index(index, @fields[:como_conheceu_aiesec])
    $enum_conheceu.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def pessoa_que_indicou(index)
    i = get_external_id_index(index, @fields[:pessoa_que_indicou])
    fields(index, i).to_s unless i.nil?
  end

  def voluntario_ferias?(index)
    i = get_external_id_index(index, @fields[:voluntario_ferias])
    $enum_inscricao_especifica.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  def projeto_especifico(index)
    i = get_external_id_index(index, @fields[:vaga_especifica])
    fields(index, i).to_s unless i.nil?
  end
end