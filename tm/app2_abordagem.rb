require_relative '../control/podio_app_control'
require_relative '../enums'

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
			:abordado => 'foi-abordado',
			:compareceu_dinamica => 'compareceu-a-dinamica'
		}
	end

	# Getter for name of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Name of the addressed
	def nome_completo(index)
		i = get_field_index_by_external_id(index, @fields[:nome])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for name of the addressed
	# @param param [String] The value you want to set
	# @return [String] Name of the addressed
	def set_nome_completo(param)
		@nome = param.to_s
	end

	# Getter for  of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String]  of the addressed
	def sexo(index)
		i = get_field_index_by_external_id(index, @fields[:sexo])
		$enum_sexo.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for sex of the addressed
	# @param param [String] The value you want to set
	# @return [Integer] Category Sex id of the addressed
	def set_sexo(param)
		@sexo = $enum_sexo[param]
	end

	# Getter for  of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String]  of the addressed
	def data_nascimento(index)
		i = get_field_index_by_external_id(index, @fields[:data_nascimento])
		DateTime.strptime(@item[0][0][:fields][i]['values'][0]['start_date'] + ' 00:00:00','%Y-%m-%d %H:%M:%S') unless i.nil?
	end

	# Setter for data_nascimento of the addressed
	# @param param [String] The value you want to set
	def set_data_nascimento(param)
		@data_nascimento = param.strftime('%Y-%m-%d %H:%M:%S')
	end

	# Setter for data_nascimento date format of the addressed
	# @param year [Integer] 
	# @param month [Integer] 
	# @param day [Integer] 
	# @param hour [Integer] 
	# @param minute [Integer] 
	def set_data_nascimento_format(year,month,day,hour,minute,second)
		@data_nascimento = DateTime.new(year,month,day,hour,minute,second).strftime('%Y-%m-%d %H:%M:%S')
	end

	# Getter for phones of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Array] List of Hashs with phone numbers of the addressed
	def phones(index)
		i = get_field_index_by_external_id(index, @fields[:telefone])
		values(index, i) unless i.nil?
	end

	# Setter for phones of the addressed
	# @param param [Array] The values you want to set
	def set_phones(param)
		@phones = param
	end

	# Getter for telefone of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Phone of the addressed
	def telefone(index)
		i = get_field_index_by_external_id(index, @fields[:telefone_old])
		fields(index, i).to_s.gsub(/[^0-9]/,'') unless i.nil?
	end

	# Setter for telefone of the addressed
	# @param param [String] The value you want to set
	def set_telefone(param)
		param.gsub!(/[^0-9]/,'')
		@telefone = param
	end

	# Getter for celular of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Celphone of the addressed
	def celular(index)
		i = get_field_index_by_external_id(index, @fields[:celular])
		fields(index, i).to_s.gsub(/[^0-9]/,'') unless i.nil?
	end

	# Setter for celular of the addressed
	# @param param [String] The value you want to set
	def set_celular(param)
		param.gsub!(/[^0-9]/,'')
		@celular = param
	end

	# Getter for operadora of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of company phone of the addressed
	def operadora(index)
		i = get_field_index_by_external_id(index, @fields[:operadora])
		$enum_operadora.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for operadora of the addressed
	# @param param [Integer] The value you want to set
	def set_operadora(param)
		@operadora = $enum_operadora[param]
	end

	# Getter for emails of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Array] List of hashs emails of the addresseds
	def emails(index)
		i = get_field_index_by_external_id(index, @fields[:email])
		values(index, i) unless i.nil?
	end

	# Setter for emails of the addressed
	# @param param [Array] The values you want to set
	def set_emails(param)
		@emails = param
	end

	# Getter for email_text of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Old Email of the addressed
	def email_text(index)
		i = get_field_index_by_external_id(index, @fields[:email_old])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for email_text of the addressed
	# @param param [String] The value you want to set
	def set_email_text(param)
		@email_text = param
	end

	# Getter for endereco of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Street of the addressed
	def endereco(index)
		i = get_field_index_by_external_id(index, @fields[:endereco])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for endereco of the addressed
	# @param param [String] The value you want to set
	def set_endereco(param)
		@endereco = param
	end

	# Getter for cep of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] CEP of the addressed
	def cep(index)
		i = get_field_index_by_external_id(index, @fields[:cep])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for cep of the addressed
	# @param param [String] The value you want to set
	def set_cep(param)
		@cep = param
	end

	# Getter for cidade of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] City of the addressed
	def cidade(index)
		i = get_field_index_by_external_id(index, @fields[:cidade])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for cidade of the addressed
	# @param param [String] The value you want to set
	def set_cidade(param)
		@cidade = param
	end

	# Getter for estado_id of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Id of referene of state of the addressed
	def estado_id(index)
		i = get_field_index_by_external_id(index, @fields[:estado])
		fields(index, i)['item_id'].to_i unless i.nil?
	end

	# Setter for estado_id of the addressed
	# @param param [Integer] The value you want to set
	def set_estado_id(param)
		@estado = param
	end

	# Getter for formacao of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of formacao of the addressed
	def formacao(index)
		i = get_field_index_by_external_id(index, @fields[:formacao])
		$enum_formacao.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for formacao of the addressed
	# @param param [Integer] The value you want to set
	def set_formacao(param)
		@formacao = $enum_formacao[param]
	end

	# Getter for curso of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Course of the addressed
	def curso(index)
		i = get_field_index_by_external_id(index, @fields[:curso])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for curso of the addressed
	# @param param [String] The value you want to set
	def set_curso(param)
		@curso = param
	end

	# Getter for  of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of faculdade of the addressed
	def semestre(index)
		i = get_field_index_by_external_id(index, @fields[:semestre])
		$enum_semestre.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for semestre of the addressed
	# @param param [Integer] The value you want to set
	def set_semestre(param)
		@semestre = $enum_semestre[param]
	end

	# Getter for faculdade of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Name of faculdade of the addressed
	def faculdade(index)
		i = get_field_index_by_external_id(index, @fields[:faculdade])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for faculdade of the addressed
	# @param param [String] The value you want to set
	def set_faculdade(param)
		@faculdade = param
	end

	# Getter for ingles of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of ingles of the addressed
	def ingles(index)
		i = get_field_index_by_external_id(index, @fields[:ingles])
		$enum_lingua.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for ingles of the addressed
	# @param param [Integer] The value you want to set
	def set_ingles(param)
		@ingles = $enum_lingua[param]
	end

	# Getter for espanhol of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of espanhol of the addressed
	def espanhol(index)
		i = get_field_index_by_external_id(index, @fields[:espanhol])
		$enum_lingua.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for espanhol of the addressed
	# @param param [Integer] The value you want to set
	def set_espanhol(param)
		@espanhol = $enum_lingua[param]
	end

	# Getter for entidade_id of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Id of referene of entity of the addressed
	def entidade_id(index)
		i = get_field_index_by_external_id(index, @fields[:entidade])
		fields(index, i)['item_id'].to_i unless i.nil?
	end

	# Setter for entidade_id of the addressed
	# @param param [Integer] The value you want to set
	def set_entidade(param)
		@entidade = param
	end

	# Getter for turno of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of turno of the addressed
	def turno(index)
		i = get_field_index_by_external_id(index, @fields[:turno])
		$enum_turno.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for turno of the addressed
	# @param param [Integer] The value you want to set
	def set_turno(param)
		@turno = $enum_turno[param]
	end

	# Getter for programa_interesse of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of programa_interesse of the addressed
	def programa_interesse(index)
		i = get_field_index_by_external_id(index, @fields[:programa_interesse])
		$enum_programa.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for programa_interesse of the addressed
	# @param param [Integer] The value you want to set
	def set_programa_interesse(param)
		@programa_interesse = $enum_programa[param]
	end

	# Getter for conheceu_aiesec of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of conheceu_aiesec of the addressed
	def conheceu_aiesec(index)
		i = get_field_index_by_external_id(index, @fields[:como_conheceu_aiesec])
		$enum_conheceu.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for conheceu_aiesec of the addressed
	# @param param [Integer] The value you want to set
	def set_conheceu_aiesec(param)
		@conheceu_aiesec = $enum_conheceu[param]
	end

	# Getter for pessoa_que_indicou of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Name of the addressed that indicate
	def pessoa_que_indicou(index)
		i = get_field_index_by_external_id(index, @fields[:pessoa_que_indicou])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for pessoa_que_indicou of the addressed
	# @param param [String] The value you want to set
	def set_pessoa_que_indicou(param)
		@pessoa_que_indicou = param
	end

	# Getter for voluntario_ferias of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Boolean] If addressed was just for summer volunteer
	def voluntario_ferias?(index)
		i = get_field_index_by_external_id(index, @fields[:volutnario_ferias])
		$enum_inscricao_especifica.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for voluntario_ferias of the addressed
	# @param param [Integer] The value you want to set
	def set_voluntario_ferias(param)
		@voluntario_ferias = $enum_inscricao_especifica[param]
	end

	# Getter for projeto_especifico of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of projeto_especifico of the addressed
	def projeto_especifico(index)
		i = get_field_index_by_external_id(index, @fields[:vaga_especifica])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for projeto_especifico of the addressed
	# @param param [Integer] The value you want to set
	def set_projeto_especifico(param)
		@projeto_especifico = param
	end

	# Getter for responsavel_id of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Id of referene of responsable of the addressed
	def responsavel_id(index)
		i = get_field_index_by_external_id(index, @fields[:responsavel])
		fields(index, i)['profile_id'].to_i unless i.nil?
	end

	# Setter for responsavel_id of the addressed
	# @param param [Integer] The value you want to set
	def set_responsavel_id(param)
		@responsavel = param.to_i
	end

	# Getter for abordado of the addressed == True
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Boolean] If addressed was 
    def is_abordado?(index)
      	abordado(index) == $enum_abordado.key($enum_abordado[:sim])
    end

	# Getter for abordado of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Boolean] If addressed was 
	def abordado(index)
		i = get_field_index_by_external_id(index, @fields[:abordado])
		$enum_abordado.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for abordado of the addressed
	# @param param [Integer] The value you want to set
	def set_abordado(param)
		@abordado = $enum_abordado[param]
	end

	# Test if addressed compareceu_dinamica
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Boolean] If addressed was in group selection
	def is_compareceu_dinamica?(index)
  		compareceu_dinamica(index) == $enum_boolean.key($enum_boolean[:sim])
	end

	# Getter for compareceu_dinamica of the addressed
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] If addressed was in group selection
	def compareceu_dinamica(index)
		i = get_field_index_by_external_id(index, @fields[:compareceu_dinamica])
		$enum_boolean.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for compareceu_dinamica of the addressed
	# @param param [Integer] The value you want to set
	def set_compareceu_dinamica(param)
		@compareceu_dinamica = $enum_boolean[param]
	end

	# Populate self variables with the values of intervield fields
	# @param entrevistado [App4Entrevistado] Reference of the intervield object
	# @param i [Integer] Index of the item you want to retrieve the value
	def populate(inscrito,i)
		set_nome_completo(inscrito.nome_completo(i))
		set_sexo(inscrito.sexo(i))
		set_data_nascimento(inscrito.data_nascimento(i))
		set_phones(inscrito.phones(i))
		set_telefone(inscrito.telefone(i))
		set_celular(inscrito.celular(i))
		set_operadora(inscrito.operadora(i))
		set_emails(inscrito.emails(i))
		set_email_text(inscrito.email_text(i))
		set_endereco(inscrito.endereco(i))
		set_cep(inscrito.cep(i))
		set_cidade(inscrito.cidade(i))
		set_estado_id(inscrito.estado_id(i))
		set_formacao(inscrito.formacao(i))
		set_curso(inscrito.curso(i))
		set_semestre(inscrito.semestre(i))
		set_faculdade(inscrito.faculdade(i))
		set_ingles(inscrito.ingles(i))
		set_espanhol(inscrito.espanhol(i))
		set_entidade(inscrito.entidade_id(i))
		set_turno(inscrito.turno(i))
		set_programa_interesse(inscrito.programa_interesse(i))
		set_conheceu_aiesec(inscrito.conheceu_aiesec(i))
		set_pessoa_que_indicou(inscrito.pessoa_que_indicou(i))
		set_voluntario_ferias(inscrito.voluntario_ferias?(i))
		set_projeto_especifico(inscrito.projeto_especifico(i))
		set_responsavel_id(inscrito.responsavel_id(i))
		set_abordado(inscrito.abordado(i))
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
		hash_fields.merge!(@fields[:abordado] => @abordado || abordado(index))
		hash_fields.merge!(@fields[:compareceu_dinamica] => @compareceu_dinamica || compareceu_dinamica(index))

		Podio::Item.update(item_id(index), { :fields => hash_fields })
	end

	# Create register on Podio database
	# @param index [Integer] Index of the item you want to retrieve the value
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

		Podio::Item.create(@app_id, { :fields => hash_fields })
	end

	# Delete register on Podio database
	# @param index [Integer] Index of the item you want to delete the value
	def delete(index)
		Podio::Item.delete(item_id(index))
	end

end