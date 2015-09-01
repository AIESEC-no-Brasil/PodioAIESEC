require_relative '../control/podio_app_control'
require_relative '../enums'

# App "2. Abordagem" at local TM workspaces
# @author Marcus Vinicius de Carvalho <marcus.carvalho@aiesec.net>
class App2Abordagem < PodioAppControl

	def initialize(app_id)
		super(app_id)
		@fields = {
			:nome => 'nome',
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
			:responsavel => 'responsavel-local',
      :data_abordagem => 'data-da-abordagem',
			:dinamica_marcada => 'compareceu-a-dinamica',
      :data_dinamica => 'data_da_dinamica'
		}
	end

  # Getter for name of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] Name of the lead
  def nome_completo(index)
    i = get_field_index_by_external_id(index, @fields[:nome])
    fields(index, i).to_s unless i.nil?
  end

  # Setter for name of the lead
  # @param param [String] The value you want to set
  # @return [String] Name of the lead
  def nome_completo=(param)
    @nome = param.to_s
  end

  # Getter for  of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String]  of the lead
  def sexo(index)
    i = get_field_index_by_external_id(index, @fields[:sexo])
    $enum_sexo.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Setter for sex of the lead
  # @param param [String] The value you want to set
  # @return [Integer] Category Sex id of the lead
  def sexo=(param)
    @sexo = $enum_sexo[param]
  end

  # Getter for  of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String]  of the lead
  def data_nascimento(index)
    i = get_field_index_by_external_id(index, @fields[:data_nascimento])
    DateTime.strptime(@item[0][0][:fields][i]['values'][0]['start_date'] + ' 00:00:00','%Y-%m-%d %H:%M:%S') unless i.nil?
  end

  # Setter for data_nascimento of the lead
  # @param param [String] The value you want to set
  def data_nascimento=(param)
    @data_nascimento = param.strftime('%Y-%m-%d %H:%M:%S')
  end

  # Setter for data_nascimento date format of the lead
  # @param year [Integer]
  # @param month [Integer]
  # @param day [Integer]
  # @param hour [Integer]
  # @param minute [Integer]
  def data_nascimento_format=(year,month,day,hour,minute,second)
    @data_nascimento = DateTime.new(year,month,day,hour,minute,second).strftime('%Y-%m-%d %H:%M:%S')
  end

  # Getter for phones of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Array] List of Hashs with phone numbers of the lead
  def phones(index)
    i = get_field_index_by_external_id(index, @fields[:telefone])
    values(index, i) unless i.nil?
  end

  # Setter for phones of the lead
  # @param param [Array] The values you want to set
  def phones=(param)
    @phones = param
  end

  # Getter for telefone of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] Phone of the lead
  def telefone(index)
    i = get_field_index_by_external_id(index, @fields[:telefone_old])
    fields(index, i).to_s.gsub(/[^0-9]/,'') unless i.nil?
  end

  # Setter for telefone of the lead
  # @param param [String] The value you want to set
  def telefone=(param)
    param.gsub!(/[^0-9]/,'')
    @telefone = param
  end

  # Getter for celular of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] Celphone of the lead
  def celular(index)
    i = get_field_index_by_external_id(index, @fields[:celular])
    fields(index, i).to_s.gsub(/[^0-9]/,'') unless i.nil?
  end

  # Setter for celular of the lead
  # @param param [String] The value you want to set
  def celular=(param)
    param.gsub!(/[^0-9]/,'')
    @celular = param
  end

  # Getter for operadora of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Integer] Category id of company phone of the lead
  def operadora(index)
    i = get_field_index_by_external_id(index, @fields[:operadora])
    $enum_operadora.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Setter for operadora of the lead
  # @param param [Integer] The value you want to set
  def operadora=(param)
    @operadora = $enum_operadora[param]
  end

  # Getter for emails of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Array] List of hashs emails of the leads
  def emails(index)
    i = get_field_index_by_external_id(index, @fields[:email])
    values(index, i) unless i.nil?
  end

  # Setter for emails of the lead
  # @param param [Array] The values you want to set
  def emails=(param)
    @emails = param
  end

  # Getter for email_text of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] Old Email of the lead
  def email_text(index)
    i = get_field_index_by_external_id(index, @fields[:email_old])
    fields(index, i).to_s unless i.nil?
  end

  # Setter for email_text of the lead
  # @param param [String] The value you want to set
  def email_text=(param)
    @email_text = param
  end

  # Getter for endereco of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] Street of the lead
  def endereco(index)
    i = get_field_index_by_external_id(index, @fields[:endereco])
    fields(index, i).to_s unless i.nil?
  end

  # Setter for endereco of the lead
  # @param param [String] The value you want to set
  def endereco=(param)
    @endereco = param
  end

  # Getter for cep of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Integer] CEP of the lead
  def cep(index)
    i = get_field_index_by_external_id(index, @fields[:cep])
    fields(index, i).to_s unless i.nil?
  end

  # Setter for cep of the lead
  # @param param [String] The value you want to set
  def cep=(param)
    @cep = param
  end

  # Getter for cidade of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] City of the lead
  def cidade(index)
    i = get_field_index_by_external_id(index, @fields[:cidade])
    fields(index, i).to_s unless i.nil?
  end

  # Setter for cidade of the lead
  # @param param [String] The value you want to set
  def cidade=(param)
    @cidade = param
  end

  # Getter for estado_id of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Integer] Id of referene of state of the lead
  def estado_id(index)
    i = get_field_index_by_external_id(index, @fields[:estado])
    fields(index, i)['item_id'].to_i unless i.nil?
  end

  # Setter for estado_id of the lead
  # @param param [Integer] The value you want to set
  def estado_id=(param)
    @estado = param
  end

  # Getter for formacao of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Integer] Category id of formacao of the lead
  def formacao(index)
    i = get_field_index_by_external_id(index, @fields[:formacao])
    $enum_formacao.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Setter for formacao of the lead
  # @param param [Integer] The value you want to set
  def formacao=(param)
    @formacao = $enum_formacao[param]
  end

  # Getter for curso of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] Course of the lead
  def curso(index)
    i = get_field_index_by_external_id(index, @fields[:curso])
    fields(index, i).to_s unless i.nil?
  end

  # Setter for curso of the lead
  # @param param [String] The value you want to set
  def curso=(param)
    @curso = param
  end

  # Getter for  of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Integer] Category id of faculdade of the lead
  def semestre(index)
    i = get_field_index_by_external_id(index, @fields[:semestre])
    $enum_semestre.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Setter for semestre of the lead
  # @param param [Integer] The value you want to set
  def semestre=(param)
    @semestre = $enum_semestre[param]
  end

  # Getter for faculdade of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] Name of faculdade of the lead
  def faculdade(index)
    i = get_field_index_by_external_id(index, @fields[:faculdade])
    fields(index, i).to_s unless i.nil?
  end

  # Setter for faculdade of the lead
  # @param param [String] The value you want to set
  def faculdade=(param)
    @faculdade = param
  end

  # Getter for ingles of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Integer] Category id of ingles of the lead
  def ingles(index)
    i = get_field_index_by_external_id(index, @fields[:ingles])
    $enum_lingua.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Setter for ingles of the lead
  # @param param [Integer] The value you want to set
  def ingles=(param)
    @ingles = $enum_lingua[param]
  end

  # Getter for espanhol of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Integer] Category id of espanhol of the lead
  def espanhol(index)
    i = get_field_index_by_external_id(index, @fields[:espanhol])
    $enum_lingua.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Setter for espanhol of the lead
  # @param param [Integer] The value you want to set
  def espanhol=(param)
    @espanhol = $enum_lingua[param]
  end

  # Getter for entidade_id of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Integer] Id of referene of entity of the lead
  def entidade_id(index)
    i = get_field_index_by_external_id(index, @fields[:entidade])
    fields(index, i)['item_id'].to_i unless i.nil?
  end

  # Setter for entidade_id of the lead
  # @param param [Integer] The value you want to set
  def entidade=(param)
    @entidade = param
  end

  # Getter for turno of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Integer] Category id of turno of the lead
  def turno(index)
    i = get_field_index_by_external_id(index, @fields[:turno])
    $enum_turno.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Setter for turno of the lead
  # @param param [Integer] The value you want to set
  def turno=(param)
    @turno = $enum_turno[param]
  end

  # Getter for programa_interesse of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Integer] Category id of programa_interesse of the lead
  def programa_interesse(index)
    i = get_field_index_by_external_id(index, @fields[:programa_interesse])
    $enum_programa.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Setter for programa_interesse of the lead
  # @param param [Integer] The value you want to set
  def programa_interesse=(param)
    @programa_interesse = $enum_programa[param]
  end

  # Getter for conheceu_aiesec of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Integer] Category id of conheceu_aiesec of the lead
  def conheceu_aiesec(index)
    i = get_field_index_by_external_id(index, @fields[:como_conheceu_aiesec])
    $enum_conheceu.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Setter for conheceu_aiesec of the lead
  # @param param [Integer] The value you want to set
  def conheceu_aiesec=(param)
    @conheceu_aiesec = $enum_conheceu[param]
  end

  # Getter for pessoa_que_indicou of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] Name of the lead that indicate
  def pessoa_que_indicou(index)
    i = get_field_index_by_external_id(index, @fields[:pessoa_que_indicou])
    fields(index, i).to_s unless i.nil?
  end

  # Setter for pessoa_que_indicou of the lead
  # @param param [String] The value you want to set
  def pessoa_que_indicou=(param)
    @pessoa_que_indicou = param
  end

  # Getter for voluntario_ferias of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Boolean] If lead was just for summer volunteer
  def voluntario_ferias?(index)
    i = get_field_index_by_external_id(index, @fields[:volutnario_ferias])
    $enum_inscricao_especifica.key(fields(index, i)['id'].to_i) unless i.nil?
  end

  # Setter for voluntario_ferias of the lead
  # @param param [Integer] The value you want to set
  def voluntario_ferias=(param)
    @voluntario_ferias = $enum_inscricao_especifica[param]
  end

  # Getter for projeto_especifico of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Integer] Category id of projeto_especifico of the lead
  def projeto_especifico(index)
    i = get_field_index_by_external_id(index, @fields[:vaga_especifica])
    fields(index, i).to_s unless i.nil?
  end

  # Setter for projeto_especifico of the lead
  # @param param [Integer] The value you want to set
  def projeto_especifico=(param)
    @projeto_especifico = param
  end

  # Getter for responsavel_id of the lead
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Integer] Id of referene of responsable of the lead
  def responsavel_id(index)
    i = get_field_index_by_external_id(index, @fields[:responsavel])
    fields(index, i)['profile_id'].to_i unless i.nil?
  end

  # Setter for responsavel_id of the lead
  # @param param [Integer] The value you want to set
  def responsavel_id=(param)
    @responsavel = param.to_i
  end

  # Getter for abordado of the lead == True
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [Boolean] If lead was
  def is_abordado?(index)
    self.abordado(index) == $enum_boolean[:sim]
  end

  # Getter for approached date of the addressed
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] Approached date of the addressed
  def data_abordagem(index)
    i = get_field_index_by_external_id(index, @fields[:data_abordagem])
    DateTime.strptime(@item[0][0][:fields][i]['values'][0]['start_date'] + ' 00:00:00','%Y-%m-%d %H:%M:%S') unless i.nil?
  end

  # Setter for approached date
  # @param param [DateTime] Approached date
  def data_abordagem=(param)
    @data_abordagem = param.strftime('%Y-%m-%d %H:%M:%S')
  end

	# Getter for compareceu_dinamica of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [enum_compareceu_dinamica] If addressed was in group selection
	def dinamica_marcada(index)
		i = get_field_index_by_external_id(index, @fields[:dinamica_marcada])
    $enum_dinamica_marcada.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for compareceu_dinamica of the addressed
	# @param param [Symbol] The value you want to set
	def dinamica_marcada=(param)
		@dinamica_marcada = $enum_dinamica_marcada[param]
  end

  # Getter for approached date of the addressed
  # @param index [Integer] Index of the item you want to retrieve the value
  # @return [String] Approached date of the addressed
  def data_dinamica(index)
    i = get_field_index_by_external_id(index, @fields[:data_abordagem])
    DateTime.strptime(@item[0][0][:fields][i]['values'][0]['start_date'] + ' 00:00:00','%Y-%m-%d %H:%M:%S') unless i.nil?
  end

  # Setter for approached date
  # @param param [DateTime] Approached date
  def data_dinamica=(param)
    @data_dinamica = param.strftime('%Y-%m-%d %H:%M:%S')
  end

	# Populate self variables with the values of intervield fields
	# @param inscrito [App1Inscrito] Reference of the intervield object
  # @param i [Integer] Index of the item you want to retrieve the value
	# @return [nil]
	def populate(inscrito,i)
		self.nome_completo=(inscrito.nome_completo(i))
		self.sexo=(inscrito.sexo(i))
		self.data_nascimento=(inscrito.data_nascimento(i))
		self.phones=(inscrito.phones(i))
		self.telefone=(inscrito.telefone(i))
		self.celular=(inscrito.celular(i))
		self.operadora=(inscrito.operadora(i))
		self.emails=(inscrito.emails(i))
		self.email_text=(inscrito.email_text(i))
		self.endereco=(inscrito.endereco(i))
		self.cep=(inscrito.cep(i))
		self.cidade=(inscrito.cidade(i))
		self.estado_id=(inscrito.estado_id(i))
		self.formacao=(inscrito.formacao(i))
		self.curso=(inscrito.curso(i))
		self.semestre=(inscrito.semestre(i))
		self.faculdade=(inscrito.faculdade(i))
		self.ingles=(inscrito.ingles(i))
		self.espanhol=(inscrito.espanhol(i))
		self.entidade=(inscrito.entidade(i))
		self.turno=(inscrito.turno(i))
		self.programa_interesse=(inscrito.programa_interesse(i))
		self.conheceu_aiesec=(inscrito.conheceu_aiesec(i))
		self.pessoa_que_indicou=(inscrito.pessoa_que_indicou(i))
		self.voluntario_ferias=(inscrito.voluntario_ferias?(i))
		self.projeto_especifico=(inscrito.projeto_especifico(i))
		self.responsavel_id=(inscrito.responsavel_id(i))
    self.dinamica_marcada=($enum_dinamica_marcada[:nao])
    self.data_abordagem=(DateTime.current)
	end

	# Update register on Podio database
	# @param index [Integer] Index of the item you want to retrieve the value
	def update(index)
		hash_fields = {}
		hash_fields.merge!(@fields[:nome] => @nome || nome_completo(index))
		hash_fields.merge!(@fields[:sexo] => @sexo || sexo(index))
		hash_fields.merge!(@fields[:data_nascimento] => {'start' => @data_nascimento || data_nascimento(index)})
		hash_fields.merge!(@fields[:telefone] => @phones || phones(index))
		hash_fields.merge!(@fields[:telefone_old] => @telefone || telefone(index))
		hash_fields.merge!(@fields[:celular] => @celular || celular(index))
		hash_fields.merge!(@fields[:operadora] => @operadora || operadora(index))
		hash_fields.merge!(@fields[:email] => @emails || emails(index))
		hash_fields.merge!(@fields[:email_old] => @email_text || email_text(index))
		hash_fields.merge!(@fields[:endereco] => @endereco || endereco(index))
		hash_fields.merge!(@fields[:cep] => @cep || cep(index))
		hash_fields.merge!(@fields[:cidade] => @cidade || cidade(index))
		hash_fields.merge!(@fields[:estado] => @estado || estado_id(index))
		hash_fields.merge!(@fields[:formacao] => @formacao || formacao(index))
		hash_fields.merge!(@fields[:curso] => @curso || curso(index))
		hash_fields.merge!(@fields[:semestre] => @semestre || semestre(index))
		hash_fields.merge!(@fields[:faculdade] => @faculdade || faculdade(index))
		hash_fields.merge!(@fields[:ingles] => @ingles || ingles(index))
		hash_fields.merge!(@fields[:espanhol] => @espanhol || espanhol(index))
		hash_fields.merge!(@fields[:entidade] => @entidade || entidade_id(index))
		hash_fields.merge!(@fields[:turno] => @turno || turno(index)) unless @turno.nil?
		hash_fields.merge!(@fields[:programa_interesse] => @programa_interesse || programa_interesse(index))
		hash_fields.merge!(@fields[:como_conheceu_aiesec] => @conheceu_aiesec || conheceu_aiesec(index))
		hash_fields.merge!(@fields[:pessoa_que_indicou] => @pessoa_que_indicou || pessoa_que_indicou(index))
		hash_fields.merge!(@fields[:voluntario_ferias] => @voluntario_ferias || voluntario_ferias?(index))
		hash_fields.merge!(@fields[:vaga_especifica] => @projeto_especifico || projeto_especifico(index))
		hash_fields.merge!(@fields[:responsavel] => @responsavel || responsavel_id(index))
		hash_fields.merge!(@fields[:data_abordagem] => @data_abordagem || data_abordagem(index))
    hash_fields.merge!(@fields[:dinamica_marcada] => @dinamica_marcada || dinamica_marcada(index))
    hash_fields.merge!(@fields[:data_dinamica] => @data_dinamica || data_dinamica(index))

		Podio::Item.update(item_id(index), { :fields => hash_fields })
	end

	# Create register on Podio database
	def create
		hash_fields = {}
		hash_fields.merge!(@fields[:nome] => @nome) unless @nome.nil?
		hash_fields.merge!(@fields[:sexo] => @sexo) unless @sexo.nil?
		hash_fields.merge!(@fields[:data_nascimento] => {'start' => @data_nascimento}) unless @data_nascimento.nil?
		hash_fields.merge!(@fields[:telefone] => @phones) unless @phones.nil?
		hash_fields.merge!(@fields[:telefone_old] => @telefone) unless @telefone.nil?
		hash_fields.merge!(@fields[:celular] => @celular) unless @celular.nil?
		hash_fields.merge!(@fields[:operadora] => @operadora) unless @operadora.nil?
		hash_fields.merge!(@fields[:email] => @emails) unless @emails.nil?
		hash_fields.merge!(@fields[:email_old] => @email_text) unless @email_text.nil?
		hash_fields.merge!(@fields[:endereco] => @endereco) unless @endereco.nil?
		hash_fields.merge!(@fields[:cep] => @cep) unless @cep.nil?
		hash_fields.merge!(@fields[:cidade] => @cidade) unless @cidade.nil?
		hash_fields.merge!(@fields[:estado] => @estado) unless @estado.nil?
		hash_fields.merge!(@fields[:formacao] => @formacao) unless @formacao.nil?
		hash_fields.merge!(@fields[:curso] => @curso) unless @curso.nil?
		hash_fields.merge!(@fields[:semestre] => @semestre) unless @semestre.nil?
		hash_fields.merge!(@fields[:faculdade] => @faculdade) unless @faculdade.nil?
		hash_fields.merge!(@fields[:ingles] => @ingles) unless @ingles.nil?
		hash_fields.merge!(@fields[:espanhol] => @espanhol) unless @espanhol.nil?
		hash_fields.merge!(@fields[:entidade] => @entidade) unless @entidade.nil?
		hash_fields.merge!(@fields[:turno] => @turno) unless @turno.nil?
		hash_fields.merge!(@fields[:programa_interesse] => @programa_interesse) unless @programa_interesse.nil?
		hash_fields.merge!(@fields[:como_conheceu_aiesec] => @conheceu_aiesec) unless @conheceu_aiesec.nil?
		hash_fields.merge!(@fields[:pessoa_que_indicou] => @pessoa_que_indicou) unless @pessoa_que_indicou.nil?
		hash_fields.merge!(@fields[:voluntario_ferias] => @voluntario_ferias) unless @voluntario_ferias.nil?
		hash_fields.merge!(@fields[:vaga_especifica] => @projeto_especifico) unless @projeto_especifico.nil?
		hash_fields.merge!(@fields[:responsavel] => @responsavel) unless @responsavel.nil?
    hash_fields.merge!(@fields[:data_abordagem] => @data_abordagem) unless @data_abordagem.nil?
		hash_fields.merge!(@fields[:dinamica_marcada] => @dinamica_marcada) unless @dinamica_marcada.nil?
    hash_fields.merge!(@fields[:data_dinamica] => @data_dinamica) unless @data_dinamica.nil?

		Podio::Item.create(@app_id, { :fields => hash_fields })
  end

  # Delete register on Podio database
  # @param index [Integer] Index of the item you want to delete
  def delete(index)
    Podio::Item.delete(item_id(index))
  end

end