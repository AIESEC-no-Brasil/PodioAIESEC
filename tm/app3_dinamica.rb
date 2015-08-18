require_relative '../control/podio_app_control'
require_relative '../enums'

class App3Dinamica < PodioAppControl

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
			:entrevistado => 'entrevistado'
		}
		end

		def nome_completo(index)
			i = get_field_index_by_external_id(index, @fields[:nome])
			fields(index, i).to_s unless i.nil?
		end

		def set_nome_completo(param)
			@nome = param.to_s
		end

		def sexo(index)
			i = get_field_index_by_external_id(index, @fields[:sexo])
			$enum_sexo.key(fields(index, i)['id'].to_i) unless i.nil?
		end

		def set_sexo(param)
			@sexo = $enum_sexo[param]
		end

		def data_nascimento(index)
			i = get_field_index_by_external_id(index, @fields[:data_nascimento])
			DateTime.strptime(@item[0][0][:fields][i]['values'][0]['start_date'] + ' 00:00:00','%Y-%m-%d %H:%M:%S') unless i.nil?
		end

		def set_data_nascimento(param)
			@data_nascimento = param.strftime('%Y-%m-%d %H:%M:%S')
		end

		def set_data_nascimento_format(year,month,day,hour,minute,second)
			@data_nascimento = DateTime.new(year,month,day,hour,minute,second).strftime('%Y-%m-%d %H:%M:%S')
		end

		def phones(index)
			i = get_field_index_by_external_id(index, @fields[:telefone])
			values(index, i) unless i.nil?
		end

		def set_phones(param)
			@phones = param
		end

		def telefone(index)
			i = get_field_index_by_external_id(index, @fields[:telefone_old])
			fields(index, i).to_s.gsub(/[^0-9]/,'') unless i.nil?
		end

		def set_telefone(param)
			param.gsub!(/[^0-9]/,'')
			@telefone = param
		end

		def celular(index)
			i = get_field_index_by_external_id(index, @fields[:celular])
			fields(index, i).to_s.gsub(/[^0-9]/,'') unless i.nil?
		end

		def set_celular(param)
			param.gsub!(/[^0-9]/,'')
			@celular = param
		end

		def operadora(index)
			i = get_field_index_by_external_id(index, @fields[:operadora])
			$enum_operadora.key(fields(index, i)['id'].to_i) unless i.nil?
		end

		def set_operadora(param)
			@operadora = $enum_operadora[param]
		end

		def emails(index)
			i = get_field_index_by_external_id(index, @fields[:email])
			values(index, i) unless i.nil?
		end

		def set_emails(param)
			@emails = param
		end

		def email_text(index)
			i = get_field_index_by_external_id(index, @fields[:email_old])
			fields(index, i).to_s unless i.nil?
		end

		def set_email_text(param)
			@email_text = param
		end

		def endereco(index)
			i = get_field_index_by_external_id(index, @fields[:endereco])
			fields(index, i).to_s unless i.nil?
		end

		def set_endereco(param)
			@endereco = param
		end

		def cep(index)
			i = get_field_index_by_external_id(index, @fields[:cep])
			fields(index, i).to_s unless i.nil?
		end

		def set_cep(param)
			@cep = param
		end

		def cidade(index)
			i = get_field_index_by_external_id(index, @fields[:cidade])
			fields(index, i).to_s unless i.nil?
		end

		def set_cidade(param)
			@cidade = param
		end

		def estado_id(index)
			i = get_field_index_by_external_id(index, @fields[:estado])
			fields(index, i)['item_id'].to_i unless i.nil?
		end

		def set_estado_id(param)
			@estado = param
		end

		def formacao(index)
			i = get_field_index_by_external_id(index, @fields[:formacao])
			$enum_formacao.key(fields(index, i)['id'].to_i) unless i.nil?
		end

		def set_formacao(param)
			@formacao = $enum_formacao[param]
		end

		def curso(index)
			i = get_field_index_by_external_id(index, @fields[:curso])
			fields(index, i).to_s unless i.nil?
		end

		def set_curso(param)
			@curso = param
		end

		def semestre(index)
			i = get_field_index_by_external_id(index, @fields[:semestre])
			$enum_semestre.key(fields(index, i)['id'].to_i) unless i.nil?
		end

		def set_semestre(param)
			@semestre = $enum_semestre[param]
		end

		def faculdade(index)
			i = get_field_index_by_external_id(index, @fields[:faculdade])
			fields(index, i).to_s unless i.nil?
		end

		def set_faculdade(param)
			@faculdade = param
		end

		def ingles(index)
			i = get_field_index_by_external_id(index, @fields[:ingles])
			$enum_lingua.key(fields(index, i)['id'].to_i) unless i.nil?
		end

		def set_ingles(param)
			@ingles = $enum_lingua[param]
		end

		def espanhol(index)
			i = get_field_index_by_external_id(index, @fields[:espanhol])
			$enum_lingua.key(fields(index, i)['id'].to_i) unless i.nil?
		end

		def set_espanhol(param)
			@espanhol = $enum_lingua[param]
		end

		def entidade_id(index)
			i = get_field_index_by_external_id(index, @fields[:entidade])
			fields(index, i)['item_id'].to_i unless i.nil?
		end

		def set_entidade(param)
			@entidade = param
		end

		def turno(index)
			i = get_field_index_by_external_id(index, @fields[:turno])
			$enum_turno.key(fields(index, i)['id'].to_i) unless i.nil?
		end

		def set_turno(param)
			@turno = $enum_turno[param]
		end

		def programa_interesse(index)
			i = get_field_index_by_external_id(index, @fields[:programa_interesse])
			$enum_programa.key(fields(index, i)['id'].to_i) unless i.nil?
		end

		def set_programa_interesse(param)
			@programa_interesse = $enum_programa[param]
		end

		def conheceu_aiesec(index)
			i = get_field_index_by_external_id(index, @fields[:como_conheceu_aiesec])
			$enum_conheceu.key(fields(index, i)['id'].to_i) unless i.nil?
		end

		def set_conheceu_aiesec(param)
			@conheceu_aiesec = $enum_conheceu[param]
		end

		def pessoa_que_indicou(index)
			i = get_field_index_by_external_id(index, @fields[:pessoa_que_indicou])
			fields(index, i).to_s unless i.nil?
		end

		def set_pessoa_que_indicou(param)
			@pessoa_que_indicou = param
		end

		def voluntario_ferias?(index)
			i = get_field_index_by_external_id(index, @fields[:volutnario_ferias])
			$enum_inscricao_especifica.key(fields(index, i)['id'].to_i) unless i.nil?
		end

		def set_voluntario_ferias(param)
			@voluntario_ferias = $enum_inscricao_especifica[param]
		end

		def projeto_especifico(index)
			i = get_field_index_by_external_id(index, @fields[:vaga_especifica])
			fields(index, i).to_s unless i.nil?
		end

		def set_projeto_especifico(param)
			@projeto_especifico = param
		end

		def responsavel_id(index)
			i = get_field_index_by_external_id(index, @fields[:responsavel])
			fields(index, i)['profile_id'].to_i unless i.nil?
		end

		def set_responsavel_id(param)
			@responsavel = param.to_i
		end

	    def is_abordado?(index)
	      self.abordado(index) == $enum_boolean[:sim]
	    end

		def abordado(index)
			i = get_field_index_by_external_id(index, @fields[:abordado])
			fields(index, i)['id'].to_i unless i.nil?
		end

		def set_abordado(param)
			@abordado = $enum_abordado[param]
		end

		def is_compareceu_dinamica?(index)
      		self.compareceu_dinamica(index) == $enum_boolean[:sim]
		end

		def compareceu_dinamica(index)
			i = get_field_index_by_external_id(index, @fields[:compareceu_dinamica])
			fields(index, i)['id'].to_i unless i.nil?
		end

		def set_compareceu_dinamica(param)
			@compareceu_dinamica = $enum_boolean[param]
		end

		def is_entrevistado?(index)
      		self.entrevistado(index) == $enum_boolean[:sim]
		end

		def entrevistado(index)
			i = get_field_index_by_external_id(index, @fields[:entrevistado])
			fields(index, i)['id'].to_i unless i.nil?
		end

		def set_entrevistado(param)
			@entrevistado = $enum_boolean[param]
		end

		def populate(abordado,i)
			self.set_nome_completo(abordado.nome_completo(i))
			self.set_sexo(abordado.sexo(i))
			self.set_data_nascimento(abordado.data_nascimento(i))
			self.set_phones(abordado.phones(i))
			self.set_telefone(abordado.telefone(i))
			self.set_celular(abordado.celular(i))
			self.set_operadora(abordado.operadora(i))
			self.set_emails(abordado.emails(i))
			self.set_email_text(abordado.email_text(i))
			self.set_endereco(abordado.endereco(i))
			self.set_cep(abordado.cep(i))
			self.set_cidade(abordado.cidade(i))
			self.set_estado_id(abordado.estado_id(i))
			self.set_formacao(abordado.formacao(i))
			self.set_curso(abordado.curso(i))
			self.set_semestre(abordado.semestre(i))
			self.set_faculdade(abordado.faculdade(i))
			self.set_ingles(abordado.ingles(i))
			self.set_espanhol(abordado.espanhol(i))
			self.set_entidade(abordado.entidade_id(i))
			self.set_turno(abordado.turno(i))
			self.set_programa_interesse(abordado.programa_interesse(i))
			self.set_conheceu_aiesec(abordado.conheceu_aiesec(i))
			self.set_pessoa_que_indicou(abordado.pessoa_que_indicou(i))
			self.set_voluntario_ferias(abordado.voluntario_ferias?(i))
			self.set_projeto_especifico(abordado.projeto_especifico(i))
			self.set_responsavel_id(abordado.responsavel_id(i))
			self.set_abordado(abordado.abordado(i))
			self.set_compareceu_dinamica(abordado.compareceu_dinamica(i))
		end

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

			Podio::Item.update(item_id(index), { :fields => hash_fields })
		end

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

			Podio::Item.create(@app_id, { :fields => hash_fields })
		end

end