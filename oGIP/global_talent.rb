require_relative '../control/podio_app_control'
require_relative '../enums'

class GlobalTalent < PodioAppControl

	def initialize(app_id)
		super(app_id)
		@fields = {
			:name => 'titulo',
			:sex => 'sexo',
			:birthdate => 'data-de-nascimento',
			:phone => 'telefone',
			:telefone_old => 'telefone-3',#TODO exluir
			:celular => 'celular-2',#TODO exluir
			:carrier => 'operadoras', #TODO aceitar múltiplas
			:email => 'email',
			:email_old => 'email-2',#TODO exluir
			:address => 'endereco-completo',
			:zip_code => 'cep',
			:city => 'cidade',
			:state => 'estado',
			:study_stage => 'formacao',
			:course => 'texto',
			:semester => 'semestre-2',
			:university => 'nome-da-universidadefaculdade',
			:english_level => 'nivel-de-ingles',
			:spanish_level => 'nivel-de-espanhol',
			:best_moment => 'melhor-turno-para-a-aiesec-entrar-em-contato',
			:local_aiesec => 'aiesec-mais-proxima',
			:interest => 'programa-de-intersesse',
			:marketing_channel => 'categoria',
			:indication => 'nome-da-pessoaentidade-que-lhe-indicou',
			:specific_opportunity => 'esta-se-candidatando-a-algum-projetovaga-especifica',
			:cv => 'cv',
			:priority => 'prioridade',
			:first_contact_date => 'data-do-primeiro-contato',
			:first_contact_responsable => 'responsavel-pelo-primeiro-contato',
			:epi_date => 'data-da-epi',
			:epi_responsable => 'responsavel-pela-epi',
			:ep_manager => 'ep-manager',
			:link_to_expa => 'link-do-perfil-no-expa',
			:applying => 'comecou-a-se-aplicar',
			:ops_date => 'data-da-ops',
			:was_in_ops => 'compareceu-a-ops',
			:match_date => 'data-do-match',
			:realize_date => 'data-do-realize', #TODO considerar início e fim
			:erase => 'apagar',
			#:link_to_mc => 'link-to-mc',
			#:link_to_local => 'link-to-local',
		}
	end

	# Getter for name of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Name of the Global Talent
	def name(index)
		i = get_field_index_by_external_id(index, @fields[:name])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for name of the Global Talent
	# @param param [String] The value you want to set
	# @return [String] Name of the Global Talent
	def name=(param)
		@name = param.to_s
	end

	# Getter for sex of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String]  of the Global Talent
	def sex(index)
		i = get_field_index_by_external_id(index, @fields[:sex])
		$enum_sexo.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for sex of the Global Talent
	# @param param [String] The value you want to set
	# @return [Integer] Category Sex id of the Global Talent
	def sex=(param)
		@sex = $enum_sexo[param]
	end

	# Getter for birthdate of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String]  of the Global Talent
	def birthdate(index)
		i = get_field_index_by_external_id(index, @fields[:birthdate])
		date = values(index, i)[0]['start'] unless i.nil?
		DateTime.strptime(date,'%Y-%m-%d %H:%M:%S') unless date.nil?
	end

	# Setter for birthdate of the Global Talent
	# @param param [String] The value you want to set
	def birthdate=(param)
		@birthdate = param.strftime('%Y-%m-%d %H:%M:%S') unless param.nil?
	end

	# Setter for data_nascimento date format of the Global Talent
	# @param year [Integer] 
	# @param month [Integer] 
	# @param day [Integer] 
	# @param hour [Integer] 
	# @param minute [Integer] 
	def birthdate_format=(year,month,day,hour,minute,second)
		@birthdate = DateTime.new(year,month,day,hour,minute,second).strftime('%Y-%m-%d %H:%M:%S')
	end

	# Getter for phones of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Array] List of Hashs with phone numbers of the Global Talent
	def phones(index)
		i = get_field_index_by_external_id(index, @fields[:phone])
		values(index, i) unless i.nil?
	end

	# Setter for phones of the Global Talent
	# @param param [Array] The values you want to set
	def phones=(param)
		@phones = param
	end

	# Getter for telefone of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Phone of the Global Talent
	def telefone(index)
		i = get_field_index_by_external_id(index, @fields[:telefone_old])
		fields(index, i).to_s.gsub(/[^0-9]/,'') unless i.nil?
	end

	# Setter for telefone of the Global Talent
	# @param param [String] The value you want to set
	def set_telefone(param)
		param.gsub!(/[^0-9]/,'')
		@telefone = param
	end

	# Getter for celular of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Celphone of the Global Talent
	def celular(index)
		i = get_field_index_by_external_id(index, @fields[:celular])
		fields(index, i).to_s.gsub(/[^0-9]/,'') unless i.nil?
	end

	# Setter for celular of the Global Talent
	# @param param [String] The value you want to set
	def set_celular(param)
		param.gsub!(/[^0-9]/,'')
		@celular = param
	end

	# Getter for carrier of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of company phone of the Global Talent
	def carrier(index)
		i = get_field_index_by_external_id(index, @fields[:carrier])
		$enum_operadora.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for carrier of the Global Talent
	# @param param [Integer] The value you want to set
	def carrier=(param)
		@carrier = $enum_operadora[param]
	end

	# Getter for emails of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Array] List of hashs emails of the Global Talents
	def emails(index)
		i = get_field_index_by_external_id(index, @fields[:email])
		values(index, i) unless i.nil?
	end

	# Setter for emails of the Global Talent
	# @param param [Array] The values you want to set
	def emails=(param)
		@emails = param
	end

	# Getter for email_text of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Old Email of the Global Talent
	def email_text(index)
		i = get_field_index_by_external_id(index, @fields[:email_old])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for email_text of the Global Talent
	# @param param [String] The value you want to set
	def set_email_text(param)
		@email_text = param
	end

	# Getter for address of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Address of the Global Talent
	def address(index)
		i = get_field_index_by_external_id(index, @fields[:address])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for address of the Global Talent
	# @param param [String] The value you want to set
	def address=(param)
		@address = param
	end

	# Getter for zip_code of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Zip code of the Global Talent
	def zip_code(index)
		i = get_field_index_by_external_id(index, @fields[:zip_code])
		fields(index, i).to_i unless i.nil?
	end

	# Setter for zip_code of the Global Talent
	# @param param [String] The value you want to set
	def zip_code=(param)
		@zip_code = param.to_i unless param.nil?
	end

	# Getter for city of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] City of the Global Talent
	def city(index)
		i = get_field_index_by_external_id(index, @fields[:city])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for city of the Global Talent
	# @param param [String] The value you want to set
	def city=(param)
		@city = param
	end

	# Getter for state_id of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Id of referene of state of the Global Talent
	def state_id(index)
		i = get_field_index_by_external_id(index, @fields[:state])
		fields(index, i)['item_id'].to_i unless i.nil?
	end

	# Setter for state_id of the Global Talent
	# @param param [Integer] The value you want to set
	def state_id=(param)
		@state_id = param.to_i unless param.nil?
	end

	# Getter for study_stage of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of study_stage of the Global Talent
	def study_stage(index)
		i = get_field_index_by_external_id(index, @fields[:study_stage])
		$enum_formacao.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for study_stage of the Global Talent
	# @param param [Integer] The value you want to set
	def study_stage=(param)
		@study_stage = $enum_formacao[param]
	end

	# Getter for course of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Course of the Global Talent
	def course(index)
		i = get_field_index_by_external_id(index, @fields[:course])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for course of the Global Talent
	# @param param [String] The value you want to set
	def course=(param)
		@course = param
	end

	# Getter for semester of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Semester of the Global Talent
	def semester(index)
		i = get_field_index_by_external_id(index, @fields[:semester])
		$enum_semester.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for semester of the Global Talent
	# @param param [Integer] The value you want to set
	def semester=(param)
		@semester = $enum_semester[param]
	end

	# Getter for university of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Name of university of the Global Talent
	def university(index)
		i = get_field_index_by_external_id(index, @fields[:university])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for university of the Global Talent
	# @param param [String] The value you want to set
	def university=(param)
		@university = param
	end

	# Getter for english_level of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of english_level of the Global Talent
	def english_level(index)
		i = get_field_index_by_external_id(index, @fields[:english_level])
		$enum_lingua.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for english_level of the Global Talent
	# @param param [Integer] The value you want to set
	def english_level=(param)
		@english_level = $enum_lingua[param]
	end

	# Getter for spanish_level of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of spanish_level of the Global Talent
	def spanish_level(index)
		i = get_field_index_by_external_id(index, @fields[:spanish_level])
		$enum_lingua.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for spanish_level of the Global Talent
	# @param param [Integer] The value you want to set
	def spanish_level=(param)
		@spanish_level = $enum_lingua[param]
	end

	# Getter for best_moment of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of best_moment of the Global Talent
	def best_moment(index)
		i = get_field_index_by_external_id(index, @fields[:best_moment])
		$enum_turno.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for best_moment of the Global Talent
	# @param param [Integer] The value you want to set
	def best_moment=(param)
		@best_moment = $enum_turno[param]
	end

	# Getter for local_aiesec of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Id of referene of local_aiesec of the Global Talent
	def local_aiesec_id(index)
		i = get_field_index_by_external_id(index, @fields[:local_aiesec])
		fields(index, i)['item_id'].to_i unless i.nil?
	end

	# Setter for local_aiesec of the Global Talent
	# @param param [Integer] The value you want to set
	def local_aiesec_id=(param)
		@local_aiesec_id = param.to_i unless param.nil?
	end

	# Getter for interest of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of interest of the Global Talent
	def interest(index)
		i = get_field_index_by_external_id(index, @fields[:interest])
		$enum_interest.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for interest of the Global Talent
	# @param param [Integer] The value you want to set
	def interest=(param)
		@interest = $enum_interest[param]
	end

	# Getter for marketing_channel of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of marketing_channel of the Global Talent
	def marketing_channel(index)
		i = get_field_index_by_external_id(index, @fields[:marketing_channel])
		$enum_marketing_channel.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for marketing_channel of the Global Talent
	# @param param [Integer] The value you want to set
	def marketing_channel=(param)
		@marketing_channel = $enum_marketing_channel[param]
	end

	# Getter for indication of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] Name of the Global Talent that indicate
	def indication(index)
		i = get_field_index_by_external_id(index, @fields[:indication])
		fields(index, i).to_s unless i.nil?
	end

	# Setter for indication of the Global Talent
	# @param param [String] The value you want to set
	def indication=(param)
		@indication = param
	end

	# Getter for specific_opportunity of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Boolean] If Global Talent was just for summer volunteer
	def specific_opportunity(index)
		i = get_field_index_by_external_id(index, @fields[:specific_opportunity])
		$enum_boolean.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for specific_opportunity of the Global Talent
	# @param param [Integer] The value you want to set
	def specific_opportunity=(param)
		@specific_opportunity = $enum_boolean[param]
	end

	# Getter for moment of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of moment of the Global Talent
	def moment(index)
		i = get_field_index_by_external_id(index, @fields[:moment])
		$enum_moment.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for moment of the Global Talent
	# @param param [Integer] The value you want to set
	def moment=(param)
		@moment = $enum_moment[param]
	end

	# Getter for priority of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Category id of priority of the Global Talent
	def priority(index)
		i = get_field_index_by_external_id(index, @fields[:priority])
		$enum_moment.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for priority of the Global Talent
	# @param param [Integer] The value you want to set
	def priority=(param)
		@priority = $enum_priority[param]
	end

	# Getter for first_contact_date of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String]  of the Global Talent
	def first_contact_date(index)
		i = get_field_index_by_external_id(index, @fields[:first_contact_date])
		date = values(index, i)[0]['start'] unless i.nil?
		DateTime.strptime(date,'%Y-%m-%d %H:%M:%S') unless date.nil?
	end

	# Setter for first_contact_date of the Global Talent
	# @param param [String] The value you want to set
	def first_contact_date=(param)
		@first_contact_date = param.strftime('%Y-%m-%d %H:%M:%S') unless param.nil?
	end

	# Setter for first_contact_date date format of the Global Talent
	# @param year [Integer] 
	# @param month [Integer] 
	# @param day [Integer] 
	# @param hour [Integer] 
	# @param minute [Integer] 
	def first_contact_date_format=(year,month,day,hour,minute,second)
		@first_contact_date = DateTime.new(year,month,day,hour,minute,second).strftime('%Y-%m-%d %H:%M:%S')
	end

	# Getter for first_contact_responsable_id of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Id of referene of first_contact_responsable_id of the Global Talent
	def first_contact_responsable_id(index)
		i = get_field_index_by_external_id(index, @fields[:first_contact_responsable])
		fields(index, i)['profile_id'].to_i unless i.nil?
	end

	# Setter for first_contact_responsable_id of the Global Talent
	# @param param [Integer] The value you want to set
	def first_contact_responsable_id=(param)
		@first_contact_responsable_id = param.to_i unless param.nil?
	end

	# Getter for epi_date of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] epi_date of the Global Talent
	def epi_date(index)
		i = get_field_index_by_external_id(index, @fields[:epi_date])
		date = values(index, i)[0]['start_date'] unless i.nil?
		DateTime.strptime(date + ' 00:00:00','%Y-%m-%d %H:%M:%S') unless date.nil?
	end

	# Setter for epi_date of the Global Talent
	# @param param [String] The value you want to set
	def epi_date=(param)
		@epi_date = param.strftime('%Y-%m-%d %H:%M:%S') unless param.nil?
	end

	# Setter for epi_date date format of the Global Talent
	# @param year [Integer] 
	# @param month [Integer] 
	# @param day [Integer] 
	# @param hour [Integer] 
	# @param minute [Integer] 
	def epi_date_format=(year,month,day,hour,minute,second)
		@epi_date = DateTime.new(year,month,day,hour,minute,second).strftime('%Y-%m-%d %H:%M:%S')
	end

	# Getter for epi_responsable_id of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Id of referene of epi_responsable_id of the Global Talent
	def epi_responsable_id(index)
		i = get_field_index_by_external_id(index, @fields[:epi_responsable])
		fields(index, i)['profile_id'].to_i unless i.nil?
	end

	# Setter for epi_responsable_id of the Global Talent
	# @param param [Integer] The value you want to set
	def epi_responsable_id=(param)
		@epi_responsable_id = param.to_i unless param.nil?
	end

	# Getter for ep_manager_id of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Id of referene of ep_manager_id of the Global Talent
	def ep_manager_id(index)
		i = get_field_index_by_external_id(index, @fields[:ep_manager])
		fields(index, i)['profile_id'].to_i unless i.nil?
	end

	# Setter for ep_manager_id of the Global Talent
	# @param param [Integer] The value you want to set
	def ep_manager_id=(param)
		@ep_manager_id = param.to_i unless param.nil?
	end

	# Getter for link_to_expa of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Id of referene of ep_manager_id of the Global Talent
	def link_to_expa(index)
		i = get_field_index_by_external_id(index, @fields[:link_to_expa])
		field = values(index, i) unless i.nil?
		field[0]["embed"] unless field.nil?
	end

	# Setter for link_to_expa of the Global Talent
	# @param param [Integer] The value you want to set
	def link_to_expa=(param)
		@link_to_expa = param
	end


	# Getter for applying of the Global Talent == True
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Boolean] If Global Talent was applying
    def applying?(index)
  		applying(index) == $enum_boolean.key($enum_boolean[:sim])
    end

	# Getter for applying of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Boolean] If Global Talent was applying
	def applying(index)
		i = get_field_index_by_external_id(index, @fields[:applying])
		$enum_boolean.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for applying of the Global Talent
	# @param param [Integer] The value you want to set
	def applying=(param)
		@applying = $enum_boolean[param]
	end

	# Getter for ops_date of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] ops_date of the Global Talent
	def ops_date(index)
		i = get_field_index_by_external_id(index, @fields[:ops_date])
		date = values(index, i)[0]['start'] unless i.nil?
		DateTime.strptime(date,'%Y-%m-%d %H:%M:%S') unless date.nil?
	end

	# Setter for ops_date of the Global Talent
	# @param param [String] The value you want to set
	def ops_date=(param)
		@ops_date = param.strftime('%Y-%m-%d %H:%M:%S') unless param.nil?
	end

	# Setter for ops_date date format of the Global Talent
	# @param year [Integer] 
	# @param month [Integer] 
	# @param day [Integer] 
	# @param hour [Integer] 
	# @param minute [Integer] 
	def ops_date_format=(year,month,day,hour,minute,second)
		@ops_date = DateTime.new(year,month,day,hour,minute,second).strftime('%Y-%m-%d %H:%M:%S')
	end

	# Getter for was_in_ops of the Global Talent == True
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Boolean] If Global Talent was 
    def was_in_ops?(index)
  		was_in_ops(index) == $enum_boolean.key($enum_boolean[:sim])
    end

	# Getter for was_in_ops of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Boolean] If Global Talent was 
	def was_in_ops(index)
		i = get_field_index_by_external_id(index, @fields[:was_in_ops])
		$enum_boolean.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for was_in_ops of the Global Talent
	# @param param [Integer] The value you want to set
	def was_in_ops=(param)
		@was_in_ops = $enum_boolean[param]
	end

	# Getter for match_date of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] match_date of the Global Talent
	def match_date(index)
		i = get_field_index_by_external_id(index, @fields[:match_date])
		date = values(index, i)[0]['start'] unless i.nil?
		DateTime.strptime(date,'%Y-%m-%d %H:%M:%S') unless date.nil?
	end

	# Setter for match_date of the Global Talent
	# @param param [String] The value you want to set
	def match_date=(param)
		@match_date = param.strftime('%Y-%m-%d %H:%M:%S') unless param.nil?
	end

	# Setter for match_date date format of the Global Talent
	# @param year [Integer] 
	# @param month [Integer] 
	# @param day [Integer] 
	# @param hour [Integer] 
	# @param minute [Integer] 
	def match_date_format=(year,month,day,hour,minute,second)
		@match_date = DateTime.new(year,month,day,hour,minute,second).strftime('%Y-%m-%d %H:%M:%S')
	end

	# Getter for realize_date of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [String] realize_date of the Global Talent
	def realize_date(index)
		i = get_field_index_by_external_id(index, @fields[:realize_date])
		date = values(index, i)[0]['start'] unless i.nil?
		DateTime.strptime(date,'%Y-%m-%d %H:%M:%S') unless date.nil?
	end

	# Setter for realize_date of the Global Talent
	# @param param [String] The value you want to set
	def realize_date=(param)
		@realize_date = param.strftime('%Y-%m-%d %H:%M:%S') unless param.nil?
	end

	# Setter for realize_date date format of the Global Talent
	# @param year [Integer] 
	# @param month [Integer] 
	# @param day [Integer] 
	# @param hour [Integer] 
	# @param minute [Integer] 
	def realize_date_format=(year,month,day,hour,minute,second)
		@realize_date = DateTime.new(year,month,day,hour,minute,second).strftime('%Y-%m-%d %H:%M:%S')
	end

	# Getter for erase of the Global Talent == True
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Boolean] If Global Talent was 
    def erase?(index)
  		erase(index) == $enum_boolean.key($enum_boolean[:sim])
    end

	# Getter for erase of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Boolean] If Global Talent was 
	def erase(index)
		i = get_field_index_by_external_id(index, @fields[:erase])
		$enum_boolean.key(fields(index, i)['id'].to_i) unless i.nil?
	end

	# Setter for erase of the Global Talent
	# @param param [Integer] The value you want to set
	def erase=(param)
		@erase = $enum_boolean[param]
	end

	# Getter for link_to_mc_id of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Id of referene of link_to_mc_id of the Global Talent
	def link_to_mc_id(index)
		i = get_field_index_by_external_id(index, @fields[:link_to_mc])
		fields(index, i)['profile_id'].to_i unless i.nil?
	end

	# Setter for link_to_mc_id of the Global Talent
	# @param param [Integer] The value you want to set
	def link_to_mc_id=(param)
		@link_to_mc_id = param.to_i unless param.nil?
	end

	# Getter for link_to_local_id of the Global Talent
	# @param index [Integer] Index of the item you want to retrieve the value
	# @return [Integer] Id of referene of link_to_local_id of the Global Talent
	def link_to_local_id(index)
		i = get_field_index_by_external_id(index, @fields[:link_to_local])
		fields(index, i)['profile_id'].to_i unless i.nil?
	end

	# Setter for link_to_local_id of the Global Talent
	# @param param [Integer] The value you want to set
	def link_to_local_id=(param)
		@link_to_local_id = param.to_i unless param.nil?
	end

	# Populate self variables with the values of intervield fields
	# @param entrevistado [App4Entrevistado] Reference of the intervield other
	# @param i [Integer] Index of the item you want to retrieve the value
	def populate(other,i)
		self.name = other.name i
		self.sex = other.sex i
		self.birthdate = other.birthdate i
		self.phones = other.phones i
		self.carrier = other.carrier i
		self.emails = other.emails i
		self.address = other.address i
		self.zip_code = other.zip_code i
		self.city = other.city i
		self.state_id = other.state_id i
		self.study_stage = other.study_stage i
		self.course = other.course i
		self.semester = other.semester i
		self.university = other.university i
		self.english_level = other.english_level i
		self.spanish_level = other.spanish_level i
		self.best_moment = other.best_moment i
		self.local_aiesec_id = other.local_aiesec_id i
		self.interest = other.interest i
		self.marketing_channel = other.marketing_channel i
		self.indication = other.indication i
		self.specific_opportunity = other.specific_opportunity i
		#TODO CV
		self.moment = other.moment i
		self.priority = other.priority i
		self.first_contact_date = other.first_contact_date i
		self.first_contact_responsable_id = other.first_contact_responsable_id i
		self.epi_date = other.epi_date i
		self.epi_responsable_id = other.epi_responsable_id i
		self.ep_manager_id = other.ep_manager_id i
		self.link_to_expa = other.link_to_expa i
		self.applying = other.applying i
		self.ops_date = other.ops_date i
		self.was_in_ops = other.was_in_ops i
		self.match_date = other.match_date i
		self.realize_date = other.realize_date i
		self.erase = other.erase i
		#link_to_mc_id = other.link_to_mc_id i
		#link_to_local_id = other.link_to_local_id i
	end

	# Update register on Podio database
	# @param index [Integer] Index of the item you want to retrieve the value
	def update(index)
		hash_fields = {}
		hash_fields.merge!(@fields[:name] => @name || name(index))
		hash_fields.merge!(@fields[:sex] => @sex || sex(index))
		hash_fields.merge!(@fields[:birthdate] => {'start' => @birthdate || birthdate(index)})
		hash_fields.merge!(@fields[:phone] => @phones || phones(index))
		#hash_fields.merge!(@fields[:telefone_old] => @telefone || telefone(index))
		#hash_fields.merge!(@fields[:celular] => @celular || celular(index))
		hash_fields.merge!(@fields[:carrier] => @carrier || carrier(index))
		hash_fields.merge!(@fields[:email] => @emails || emails(index))
		#hash_fields.merge!(@fields[:email_old] => @email_text || email_text(index))
		hash_fields.merge!(@fields[:address] => @address || address(index))
		hash_fields.merge!(@fields[:zip_code] => @zip_code || zip_code(index))
		hash_fields.merge!(@fields[:city] => @city || city(index))
		hash_fields.merge!(@fields[:state] => @state_id || state_id(index))
		hash_fields.merge!(@fields[:study_stage] => @study_stage || study_stage(index))
		hash_fields.merge!(@fields[:course] => @course || course(index))
		hash_fields.merge!(@fields[:semester] => @semester || semester(index))
		hash_fields.merge!(@fields[:university] => @university || university(index))
		hash_fields.merge!(@fields[:english_level] => @english_level || english_level(index))
		hash_fields.merge!(@fields[:spanish_level] => @spanish_level || spanish_level(index))
		hash_fields.merge!(@fields[:best_moment] => @best_moment || best_moment(index)) unless @best_moment.nil?
		hash_fields.merge!(@fields[:local_aiesec] => @local_aiesec_id || local_aiesec_id(index))
		hash_fields.merge!(@fields[:interest] => @interest || interest(index))
		hash_fields.merge!(@fields[:marketing_channel] => @marketing_channel || marketing_channel(index))
		hash_fields.merge!(@fields[:indication] => @indication || indication(index))
		hash_fields.merge!(@fields[:specific_opportunity] => @specific_opportunity || specific_opportunity(index))
		hash_fields.merge!(@fields[:moment] => @moment || moment(index))
		hash_fields.merge!(@fields[:priority] => @priority || priority(index))
		hash_fields.merge!(@fields[:first_contact_date] => {'start' => @first_contact_date || first_contact_date(index)})
		hash_fields.merge!(@fields[:first_contact_responsable] => @first_contact_responsable_id || first_contact_responsable_id(index))
		hash_fields.merge!(@fields[:epi_date] => {'start' => @epi_date || epi_date(index)})
		hash_fields.merge!(@fields[:epi_responsable] => @epi_responsable_id || epi_responsable_id(index))
		hash_fields.merge!(@fields[:ep_manager] => @ep_manager_id || ep_manager_id(index))
		hash_fields.merge!(@fields[:link_to_expa] => @link_to_expa || link_to_expa(index))
		hash_fields.merge!(@fields[:applying] => @applying || applying(index))
		hash_fields.merge!(@fields[:ops_date] => {'start' => @ops_date || ops_date(index)})
		hash_fields.merge!(@fields[:was_in_ops] => @was_in_ops || was_in_ops(index))
		hash_fields.merge!(@fields[:match_date] => {'start' => @match_date || match_date(index)})
		hash_fields.merge!(@fields[:realize_date] => {'start' => @realize_date || realize_date(index)})
		hash_fields.merge!(@fields[:erase] => @erase || erase(index))
		hash_fields.merge!(@fields[:link_to_mc] => @link_to_mc_id || link_to_mc_id(index))
		hash_fields.merge!(@fields[:link_to_local] => @link_to_local_id || link_to_local_id(index))

		Podio::Item.update(item_id(index), { :fields => hash_fields })
	end

	# Create register on Podio database
	# @param index [Integer] Index of the item you want to retrieve the value
	def create
		hash_fields = {}
		hash_fields.merge!(@fields[:name] => @name) unless @name.nil?
		hash_fields.merge!(@fields[:sex] => @sex) unless @sex.nil?
		hash_fields.merge!(@fields[:birthdate] => {'start' => @birthdate}) unless @birthdate.nil?
		hash_fields.merge!(@fields[:phone] => @phones) unless @phones.nil?
		#hash_fields.merge!(@fields[:telefone_old] => @telefone) unless @telefone.nil?
		#hash_fields.merge!(@fields[:celular] => @celular) unless @celular.nil?
		hash_fields.merge!(@fields[:carrier] => @carrier) unless @carrier.nil?
		hash_fields.merge!(@fields[:email] => @emails) unless @emails.nil?
		#hash_fields.merge!(@fields[:email_old] => @email_text) unless @email_text.nil?
		hash_fields.merge!(@fields[:address] => @address) unless @address.nil?
		hash_fields.merge!(@fields[:zip_code] => @zip_code) unless @zip_code.nil?
		hash_fields.merge!(@fields[:city] => @city) unless @city.nil?
		hash_fields.merge!(@fields[:state] => @state_id) unless @state_id.nil?
		hash_fields.merge!(@fields[:study_stage] => @study_stage) unless @study_stage.nil?
		hash_fields.merge!(@fields[:course] => @course) unless @course.nil?
		hash_fields.merge!(@fields[:semester] => @semester) unless @semester.nil?
		hash_fields.merge!(@fields[:university] => @university) unless @university.nil?
		hash_fields.merge!(@fields[:english_level] => @english_level) unless @english_level.nil?
		hash_fields.merge!(@fields[:spanish_level] => @spanish_level) unless @spanish_level.nil?
		hash_fields.merge!(@fields[:best_moment] => @best_moment) unless @best_moment.nil?
		hash_fields.merge!(@fields[:local_aiesec] => @local_aiesec_id) unless @local_aiesec_id.nil?
		hash_fields.merge!(@fields[:interest] => @interest) unless @interest.nil?
		hash_fields.merge!(@fields[:marketing_channel] => @marketing_channel) unless @marketing_channel.nil?
		hash_fields.merge!(@fields[:indication] => @indication) unless @indication.nil?
		hash_fields.merge!(@fields[:specific_opportunity] => @specific_opportunity) unless @specific_opportunity.nil?
		hash_fields.merge!(@fields[:moment] => @moment) unless @moment.nil?
		hash_fields.merge!(@fields[:priority] => @priority) unless @priority.nil?
		hash_fields.merge!(@fields[:first_contact_date] => {'start' => @first_contact_date}) unless @first_contact_date.nil?
		hash_fields.merge!(@fields[:first_contact_responsable] => @first_contact_responsable_id) unless @first_contact_responsable_id.nil?
		hash_fields.merge!(@fields[:epi_date] => {'start' => @epi_date}) unless @epi_date.nil?
		hash_fields.merge!(@fields[:epi_responsable] => @epi_responsable_id) unless @epi_responsable_id.nil?
		hash_fields.merge!(@fields[:ep_manager] => @ep_manager_id) unless @ep_manager_id.nil?
		hash_fields.merge!(@fields[:link_to_expa] => @link_to_expa) unless @link_to_expa.nil?
		hash_fields.merge!(@fields[:applying] => @applying) unless @applying.nil?
		hash_fields.merge!(@fields[:ops_date] => {'start' => @ops_date}) unless @ops_date.nil?
		hash_fields.merge!(@fields[:was_in_ops] => @was_in_ops) unless @was_in_ops.nil?
		hash_fields.merge!(@fields[:match_date] => {'start' => @match_date}) unless @match_date.nil?
		hash_fields.merge!(@fields[:realize_date] => {'start' => @realize_date}) unless @realize_date.nil?
		hash_fields.merge!(@fields[:erase] => @erase) unless @erase.nil?
		hash_fields.merge!(@fields[:link_to_mc] => @link_to_mc_id) unless @link_to_mc_id.nil?
		hash_fields.merge!(@fields[:link_to_local] => @link_to_local_id) unless @link_to_local_id.nil?

		Podio::Item.create(@app_id, { :fields => hash_fields })
	end

	# delete register on Podio database
	# @param index [Integer] Index of the item you want to delete the value
	def delete(index)
		Podio::Item.delete(item_id(index))
	end
end