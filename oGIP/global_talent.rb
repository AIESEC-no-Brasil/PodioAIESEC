require_relative '../control/podio_app_control'
require_relative '../enums'

class GlobalTalent < PodioAppControl

	text_attr_accessor :name, :address, :city, :course, :university, :indication
	number_attr_accessor :zip_code
	date_attr_accessor :birthdate, :first_contact_date, :epi_date, :match_date, :realize_date, :ops_date
	boolean_attr_accessor :applying, :was_in_ops, :specific_opportunity, :erase
	category_attr_accessor :sex, :study_stage, :semester, :english_level, :spanish_level, :best_moment
	category_attr_accessor :interest, :marketing_channel, :priority, :carrier
	multiple_attr_accessor :phones, :emails
	reference_attr_accessor :state, :local_aiesec, :first_contact_responsable, :epi_responsable, :ep_manager
	link_attr_accessor :link_to_expa
	#img_attr_accessor :cv #TODO

	def initialize(app_id)
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
		super(app_id, @fields)
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