require_relative '../control/podio_app_control'
require_relative '../enums'

class App4Entrevista < PodioAppControl

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
			:abordado => 'foi-abordado',
			:compareceu_dinamica => 'compareceu-a-dinamica',
			:data_da_dinamcia => 'data-da-dinamica',
			:entrevistado => 'entrevistado',
			:virou_membro => 'virou-membro'
		}
	end

	# Getter for name of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Name of the interviewed
	def nome_completo(index)
		i = get_field_index_by_external_id(index, @fields[:nome])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for name of the interviewed
	# @param param [String] The value you want to set
	# @return [String] Name of the interviewed
	def set_nome_completo(param)
		@nome = param.to_s
	end

	# Getter for  of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String]  of the interviewed
	def sexo(index)
		i = get_field_index_by_external_id(index, @fields[:sexo])
		$enum_sexo.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for sex of the interviewed
	# @param param [String] The value you want to set
	# @return [Integer] Category Sex id of the interviewed
	def set_sexo(param)
		@sexo = $enum_sexo[param]
	end

	# Getter for  of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String]  of the interviewed
	def data_nascimento(index)
		i = get_field_index_by_external_id(index, @fields[:data_nascimento])
		DateTime.strptime(@item[0][0][:fields][i]['values'][0]['start_date'] + ' 00:00:00','%Y-%m-%d %H:%M:%S') unless i.nil?
	end

	# Setter for data_nascimento of the interviewed
	# @param param [String] The value you want to set
	def set_data_nascimento(param)
		@data_nascimento = param.strftime('%Y-%m-%d %H:%M:%S')
	end

	# Setter for data_nascimento date format of the interviewed
	# @param year [Integer] 
	# @param month [Integer] 
	# @param day [Integer] 
	# @param hour [Integer] 
	# @param minute [Integer] 
	def set_data_nascimento_format(year,month,day,hour,minute,second)
		@data_nascimento = DateTime.new(year,month,day,hour,minute,second).strftime('%Y-%m-%d %H:%M:%S')
	end

	# Getter for phones of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Array] List of Hashs with phone numbers of the interviewed
	def phones(index)
		i = get_field_index_by_external_id(index, @fields[:telefone])
		values(index, i) unless i.nil?
	end

	# Setter for phones of the interviewed
	# @param param [Array] The values you want to set
	def set_phones(param)
		@phones = param
	end

	# Getter for telefone of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Phone of the interviewed
	def telefone(index)
		i = get_field_index_by_external_id(index, @fields[:telefone_old])
		fields(index, i).to_s.gsub(/[^0-9]/,'') unless i.nil?
	end

	# Setter for telefone of the interviewed
	# @param param [String] The value you want to set
	def set_telefone(param)
		param.gsub!(/[^0-9]/,'')
		@telefone = param
	end

	# Getter for celular of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Celphone of the interviewed
	def celular(index)
		i = get_field_index_by_external_id(index, @fields[:celular])
		fields(index, i).to_s.gsub(/[^0-9]/,'') unless i.nil?
	end

	# Setter for celular of the interviewed
	# @param param [String] The value you want to set
	def set_celular(param)
		param.gsub!(/[^0-9]/,'')
		@celular = param
	end

	# Getter for operadora of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of company phone of the interviewed
	def operadora(index)
		i = get_field_index_by_external_id(index, @fields[:operadora])
		$enum_operadora.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for operadora of the interviewed
	# @param param [Integer] The value you want to set
	def set_operadora(param)
		@operadora = $enum_operadora[param]
	end

	# Getter for emails of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Array] List of hashs emails of the intervieweds
	def emails(index)
		i = get_field_index_by_external_id(index, @fields[:email])
		values(index, i) unless i.nil?
	end

	# Setter for emails of the interviewed
	# @param param [Array] The values you want to set
	def set_emails(param)
		@emails = param
	end

	# Getter for email_text of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Old Email of the interviewed
	def email_text(index)
		i = get_field_index_by_external_id(index, @fields[:email_old])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for email_text of the interviewed
	# @param param [String] The value you want to set
	def set_email_text(param)
		@email_text = param
	end

	# Getter for endereco of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Street of the interviewed
	def endereco(index)
		i = get_field_index_by_external_id(index, @fields[:endereco])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for endereco of the interviewed
	# @param param [String] The value you want to set
	def set_endereco(param)
		@endereco = param
	end

	# Getter for cep of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] CEP of the interviewed
	def cep(index)
		i = get_field_index_by_external_id(index, @fields[:cep])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for cep of the interviewed
	# @param param [String] The value you want to set
	def set_cep(param)
		@cep = param
	end

	# Getter for cidade of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] City of the interviewed
	def cidade(index)
		i = get_field_index_by_external_id(index, @fields[:cidade])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for cidade of the interviewed
	# @param param [String] The value you want to set
	def set_cidade(param)
		@cidade = param
	end

	# Getter for estado_id of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Id of referene of state of the interviewed
	def estado_id(index)
		i = get_field_index_by_external_id(index, @fields[:estado])
		fields(index, i)['item_id'].to_i unless i.nil?
	end

	# Setter for estado_id of the interviewed
	# @param param [Integer] The value you want to set
	def set_estado_id(param)
		@estado = param
	end

	# Getter for formacao of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of formacao of the interviewed
	def formacao(index)
		i = get_field_index_by_external_id(index, @fields[:formacao])
		$enum_formacao.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for formacao of the interviewed
	# @param param [Integer] The value you want to set
	def set_formacao(param)
		@formacao = $enum_formacao[param]
	end

	# Getter for curso of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Course of the interviewed
	def curso(index)
		i = get_field_index_by_external_id(index, @fields[:curso])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for curso of the interviewed
	# @param param [String] The value you want to set
	def set_curso(param)
		@curso = param
	end

	# Getter for  of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of faculdade of the interviewed
	def semestre(index)
		i = get_field_index_by_external_id(index, @fields[:semestre])
		$enum_semestre.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for semestre of the interviewed
	# @param param [Integer] The value you want to set
	def set_semestre(param)
		@semestre = $enum_semestre[param]
	end

	# Getter for faculdade of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Name of faculdade of the interviewed
	def faculdade(index)
		i = get_field_index_by_external_id(index, @fields[:faculdade])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for faculdade of the interviewed
	# @param param [String] The value you want to set
	def set_faculdade(param)
		@faculdade = param
	end

	# Getter for ingles of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of ingles of the interviewed
	def ingles(index)
		i = get_field_index_by_external_id(index, @fields[:ingles])
		$enum_lingua.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for ingles of the interviewed
	# @param param [Integer] The value you want to set
	def set_ingles(param)
		@ingles = $enum_lingua[param]
	end

	# Getter for espanhol of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of espanhol of the interviewed
	def espanhol(index)
		i = get_field_index_by_external_id(index, @fields[:espanhol])
		$enum_lingua.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for espanhol of the interviewed
	# @param param [Integer] The value you want to set
	def set_espanhol(param)
		@espanhol = $enum_lingua[param]
	end

	# Getter for entidade_id of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Id of referene of entity of the interviewed
	def entidade_id(index)
		i = get_field_index_by_external_id(index, @fields[:entidade])
		fields(index, i)['item_id'].to_i unless i.nil?
	end

	# Setter for entidade_id of the interviewed
	# @param param [Integer] The value you want to set
	def set_entidade(param)
		@entidade = param
	end

	# Getter for turno of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of turno of the interviewed
	def turno(index)
		i = get_field_index_by_external_id(index, @fields[:turno])
		$enum_turno.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for turno of the interviewed
	# @param param [Integer] The value you want to set
	def set_turno(param)
		@turno = $enum_turno[param]
	end

	# Getter for programa_interesse of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of programa_interesse of the interviewed
	def programa_interesse(index)
		i = get_field_index_by_external_id(index, @fields[:programa_interesse])
		$enum_programa.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for programa_interesse of the interviewed
	# @param param [Integer] The value you want to set
	def set_programa_interesse(param)
		@programa_interesse = $enum_programa[param]
	end

	# Getter for conheceu_aiesec of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of conheceu_aiesec of the interviewed
	def conheceu_aiesec(index)
		i = get_field_index_by_external_id(index, @fields[:como_conheceu_aiesec])
		$enum_conheceu.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for conheceu_aiesec of the interviewed
	# @param param [Integer] The value you want to set
	def set_conheceu_aiesec(param)
		@conheceu_aiesec = $enum_conheceu[param]
	end

	# Getter for pessoa_que_indicou of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Name of the interviewed that indicate
	def pessoa_que_indicou(index)
		i = get_field_index_by_external_id(index, @fields[:pessoa_que_indicou])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for pessoa_que_indicou of the interviewed
	# @param param [String] The value you want to set
	def set_pessoa_que_indicou(param)
		@pessoa_que_indicou = param
	end

	# Getter for voluntario_ferias of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Boolean] If interviewed was just for summer volunteer
	def voluntario_ferias?(index)
		i = get_field_index_by_external_id(index, @fields[:volutnario_ferias])
		$enum_inscricao_especifica.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for voluntario_ferias of the interviewed
	# @param param [Integer] The value you want to set
	def set_voluntario_ferias(param)
		@voluntario_ferias = $enum_inscricao_especifica[param]
	end

	# Getter for projeto_especifico of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of projeto_especifico of the interviewed
	def projeto_especifico(index)
		i = get_field_index_by_external_id(index, @fields[:vaga_especifica])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for projeto_especifico of the interviewed
	# @param param [Integer] The value you want to set
	def set_projeto_especifico(param)
		@projeto_especifico = param
	end

	# Getter for responsavel_id of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Id of referene of responsable of the interviewed
	def responsavel_id(index)
		i = get_field_index_by_external_id(index, @fields[:responsavel])
		fields(index, i)['profile_id'].to_i unless i.nil?
	end

	# Setter for responsavel_id of the interviewed
	# @param param [Integer] The value you want to set
	def set_responsavel_id(param)
		@responsavel = param.to_i
	end

	# Getter for virou_membro of the interviewed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Boolean] If is a interviewed
	def virou_membro(index)
		i = get_field_index_by_external_id(index, @fields[:virou_membro])
		$enum_virou_membro.key[fields(index, i)['id'].to_i] unless i.nil?
	end

	# Setter for entrevistado of the interviewed
	# @param param [Integer] The value you want to set
	def set_virou_membro(param)
		@virou_membro = $enum_virou_membro[param]
	end

	# Populate self variables with the values of intervield fields
	# @param entrevistado [App4Entrevistado] Reference of the intervield object
	# @param i [Integer] Index of the item you want to retrieve the value
	# @return [nil]
	def populate(dinamico,i)
		self.set_nome_completo(dinamico.nome_completo(i))
		self.set_sexo(dinamico.sexo(i))
		self.set_data_nascimento(dinamico.data_nascimento(i))
		self.set_phones(dinamico.phones(i))
		self.set_telefone(dinamico.telefone(i))
		self.set_celular(dinamico.celular(i))
		self.set_operadora(dinamico.operadora(i))
		self.set_emails(dinamico.emails(i))
		self.set_email_text(dinamico.email_text(i))
		self.set_endereco(dinamico.endereco(i))
		self.set_cep(dinamico.cep(i))
		self.set_cidade(dinamico.cidade(i))
		self.set_estado_id(dinamico.estado_id(i))
		self.set_formacao(dinamico.formacao(i))
		self.set_curso(dinamico.curso(i))
		self.set_semestre(dinamico.semestre(i))
		self.set_faculdade(dinamico.faculdade(i))
		self.set_ingles(dinamico.ingles(i))
		self.set_espanhol(dinamico.espanhol(i))
		self.set_entidade(dinamico.entidade_id(i))
		self.set_turno(dinamico.turno(i))
		self.set_programa_interesse(dinamico.programa_interesse(i))
		self.set_conheceu_aiesec(dinamico.conheceu_aiesec(i))
		self.set_pessoa_que_indicou(dinamico.pessoa_que_indicou(i))
		self.set_voluntario_ferias(dinamico.voluntario_ferias?(i))
		self.set_projeto_especifico(dinamico.projeto_especifico(i))
		self.set_responsavel_id(dinamico.responsavel_id(i))
		self.set_abordado(dinamico.abordado(i))
		self.set_compareceu_dinamica(dinamico.compareceu_dinamica(i))
		self.set_entrevistado(dinamico.entrevistado(i))
	end

	# Update register on Podio database
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [self] Actual updated object
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
		hash_fields.merge!(@fields[:abordado] => @abordado || abordado(index))
		hash_fields.merge!(@fields[:compareceu_dinamica] => @compareceu_dinamica || compareceu_dinamica(index))
		hash_fields.merge!(@fields[:entrevistado] => @entrevistado || entrevistado(index))
		hash_fields.merge!(@fields[:virou_membro] => @virou_membro || virou_membro(index))

		Podio::Item.update(item_id(index), { :fields => hash_fields })
	end

	# Create register on Podio database
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [self] Actual updated object
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
		hash_fields.merge!(@fields[:abordado] => @abordado) unless @abordado.nil?
		hash_fields.merge!(@fields[:compareceu_dinamica] => @compareceu_dinamica) unless @compareceu_dinamica.nil?
		hash_fields.merge!(@fields[:entrevistado] => @entrevistado) unless @entrevistado.nil?
		hash_fields.merge!(@fields[:virou_membro] => @virou_membro) unless @virou_membro.nil?

		Podio::Item.create(@app_id, { :fields => hash_fields })
	end

	# Delete register on Podio database
	# @param index [Integer] Index of the item you want to delete
	def delete(index)
		Podio::Item.delete(item_id(index))
	end

end