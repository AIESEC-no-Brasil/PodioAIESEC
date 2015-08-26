require_relative '../control/podio_app_control'
require_relative '../enums'

# TM ORS
# @author Marcus Vinicius de Carvalho <marcus.carvalho@aiesec.net>
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
               :vaga_especifica => 'caso-voce-esta-se-candidatando-a-algum-projetovaga-espe',
               :foi_transferido? => 'controle-interno-robozinho-foi-transferido'}
  end

  # Getter for name
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] Name
  def nome_completo(index)
    i = get_field_index_by_external_id(index, @fields[:nome])
    fields(index, i).to_s unless i.nil?
  end

  # Getter for gender
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [enum_sexo] Enum with gender
  def sexo(index)
    i = get_field_index_by_external_id(index, @fields[:sexo])
    $enum_sexo.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Getter for birthday
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Datetime] Datetime with birthday
  def data_nascimento(index)
    i = get_field_index_by_external_id(index, @fields[:data_nascimento])
    DateTime.strptime(@item[0][0][:fields][i]['values'][0]['start_date'] + ' 00:00:00','%Y-%m-%d %H:%M:%S') unless i.nil?
  end

  # Getter for phone numbers
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Array] Array with all phone numbers
  def phones(index)
    i = get_field_index_by_external_id(index, @fields[:telefone])
    values(index, i) unless i.nil?
  end

  # Getter for phone number
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] Phone number
  def telefone(index)
    i = get_field_index_by_external_id(index, @fields[:telefone_old])
    fields(index, i).to_s.gsub(/[^0-9]/,'') unless i.nil?
  end

  # Getter for mobile phone number
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] Mobile phone number
  def celular(index)
    i = get_field_index_by_external_id(index, @fields[:celular])
    fields(index, i).to_s.gsub(/[^0-9]/,'') unless i.nil?
  end

  # Getter for mobile phone number operator
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [enum_operadora] Enum with mobile phone number operator
  def operadora(index)
    i = get_field_index_by_external_id(index, @fields[:operadora])
    $enum_operadora.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Getter for emails
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Array] Emails
  def emails(index)
    i = get_field_index_by_external_id(index, @fields[:email])
    values(index, i) unless i.nil?
  end

  # Getter for email
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] email
  def email_text(index)
    i = get_field_index_by_external_id(index, @fields[:email_old])
    fields(index, i).to_s unless i.nil?
  end

  # Getter for address
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] address
  def endereco(index)
    i = get_field_index_by_external_id(index, @fields[:endereco])
    fields(index, i).to_s unless i.nil?
  end

  # Getter for postal code
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] Postal code
  def cep(index)
    i = get_field_index_by_external_id(index, @fields[:cep])
    fields(index, i).to_s unless i.nil?
  end

  # Getter for city
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] city
  def cidade(index)
    i = get_field_index_by_external_id(index, @fields[:cidade])
    fields(index, i).to_s unless i.nil?
  end

  # Getter for state
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Integer] State id
  def estado_id(index)
    i = get_field_index_by_external_id(index, @fields[:estado])
    fields(index, i)['item_id'].to_i unless i.nil?
  end

  # Getter for major
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [enum_formacao] Enum with major
  def formacao(index)
    i = get_field_index_by_external_id(index, @fields[:formacao])
    $enum_formacao.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Getter for course
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] course
  def curso(index)
    i = get_field_index_by_external_id(index, @fields[:curso])
    fields(index, i).to_s unless i.nil?
  end

  # Getter for semester
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [enum_semestre] Enum with semester
  def semestre(index)
    i = get_field_index_by_external_id(index, @fields[:semestre])
    $enum_semestre.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Getter for university
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] university
  def faculdade(index)
    i = get_field_index_by_external_id(index, @fields[:faculdade])
    fields(index, i).to_s unless i.nil?
  end

  # Getter for english language level
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [enum_lingua] Enum with english language level
  def ingles(index)
    i = get_field_index_by_external_id(index, @fields[:ingles])
    $enum_lingua.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Getter for spanish language level
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [enum_lingua] Enum with spanish language level
  def espanhol(index)
    i = get_field_index_by_external_id(index, @fields[:espanhol])
    $enum_lingua.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Getter for entity
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Integer] Entity ID
  def entidade_id(index)
    i = get_field_index_by_external_id(index, @fields[:entidade])
    fields(index, i)['item_id'].to_i unless i.nil?
  end

  # Getter for better time to approach the person
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [enum_turno] Enum with better time to approach
  def turno(index)
    i = get_field_index_by_external_id(index, @fields[:turno])
    $enum_turno.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Getter for interested program
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [enum_programa] Enum with interested program
  def programa_interesse(index)
    i = get_field_index_by_external_id(index, @fields[:programa_interesse])
    $enum_programa.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Getter for how the person get to know AIESEC
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [enum_conhece] Enum with information about how the person get to know AIESEC
  def conheceu_aiesec(index)
    i = get_field_index_by_external_id(index, @fields[:como_conheceu_aiesec])
    $enum_conheceu.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Getter for the name of the person that introduce AIESEC to the person
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] Name of the person
  def pessoa_que_indicou(index)
    i = get_field_index_by_external_id(index, @fields[:pessoa_que_indicou])
    fields(index, i).to_s unless i.nil?
  end

  # Getter to know if that person is interested in the summer break volunteer program
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [enum_inscricao_especifica] Enum with information about specific registration
  def voluntario_ferias?(index)
    i = get_field_index_by_external_id(index, @fields[:voluntario_ferias])
    $enum_inscricao_especifica.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Getter to know if person joined for a specific project
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] Name of the specific project
  def projeto_especifico(index)
    i = get_field_index_by_external_id(index, @fields[:vaga_especifica])
    fields(index, i).to_s unless i.nil?
  end

  # Getter to know if person register was already transfered to local workspace
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [enum_foi_transferido] Enum that indicates if person was transfered or not
  def foi_transferido(index)
    i = get_field_index_by_external_id(index, @fields[:foi_transferido?])
    $enum_foi_transferido_ors.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Getter to know if person register was already transfered to local workspace
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [enum_foi_transferido] Enum that indicates if person was transfered or not
  def foi_transferido?(index)
    i = get_field_index_by_external_id(index, @fields[:foi_transferido?])
    $enum_foi_transferido_ors.key(fields(index, i)['id'].to_i) unless i.nil?
  end



  # Mark the item as "transfered to local workspace"
  # @param index [Integer] Index of the item you want to update
  def update_transferido(index)
    Podio::Item.update(item_id(index), { :fields => {@fields[:foi_transferido?] => $enum_foi_transferido_ors[:sim]} })
  end
end