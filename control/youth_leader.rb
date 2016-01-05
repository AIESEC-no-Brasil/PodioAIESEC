require_relative '../control/podio_app_control'
require_relative '../enums'
require_relative '../utils'

class YouthLeader < PodioAppControl

	text_attr_accessor :name,  :city, :indication
	number_attr_accessor :zip_code, :id_local, :id_local_1, :id_local_2
	date_attr_accessor :birthdate
	boolean_attr_accessor :erase, :sync_with_local
	category_attr_accessor :sex, :study_stage, :semester, :english_level, :spanish_level, :best_moment
	category_attr_accessor :marketing_channel, :carrier, :graduation_year, :authorization
	multiple_attr_accessor :phones, :emails
	reference_attr_accessor :state, :local_aiesec, :university, :course

	def initialize(app_id, extra_fields)
		basic_fields = {
			:name => 'titulo',
			:sex => 'sexo',
			:birthdate => 'data-de-nascimento',
			:phones => 'telefone',
			:emails => 'email',
			:zip_code => 'cep',
			:city => 'cidade',
			:state => 'estado',
			:study_stage => 'formacao',
      :university => 'universidade',
      :course => 'curso',
			:semester => 'semestre-2',
			:graduation_year => 'ano-de-formacao',
			:english_level => 'nivel-de-ingles',
			:spanish_level => 'nivel-de-espanhol',
			:best_moment => 'melhor-turno-para-a-aiesec-entrar-em-contato',
			:local_aiesec => 'aiesec-mais-proxima',
			:marketing_channel => 'categoria',
			:indication => 'nome-da-pessoaentidade-que-lhe-indicou',
			:sync_with_local => 'transferido-para-area-local',
			:authorization => 'autorizo-receber-informacoes-sobre-os-projetos-de-inter',
      :id_local => 'id-local',
      :id_local_1 => 'id-local-1',
      :id_local_2 => 'id-local-2',
		}
		basic_fields.merge!(extra_fields) unless extra_fields.nil?
		super(app_id, basic_fields)
	end

	# Populate self variables with the values of intervield fields
	# @param entrevistado [App4Entrevistado] Reference of the intervield other
	# @param i [Integer] Index of the item you want to retrieve the value
	def populate(other,i)
		self.name = other.name i
		self.sex = other.sex i
		self.birthdate = other.birthdate i
		self.phones = other.phones i
		self.emails = other.emails i
		self.zip_code = other.zip_code i
		self.city = other.city i
		self.state_id = other.state_id i
		self.study_stage = other.study_stage i
    self.university = other.university i
		self.course = other.course i
		self.semester = other.semester i
    self.graduation_year = other.graduation_year i
		self.university = other.university i
		self.english_level = other.english_level i
		self.spanish_level = other.spanish_level i
		self.best_moment = other.best_moment i
		self.local_aiesec_id = other.local_aiesec_id i
		self.marketing_channel = other.marketing_channel i
		self.indication = other.indication i
		self.sync_with_local = other.sync_with_local i
    self.id_local = other.id_local i
    self.id_local_1 = other.id_local_1 i
    self.id_local_2 = other.id_local_2 i
	end

	def hashing_to_update(index)
		hash_fields = {}
		hash_fields.merge!(@fields[:name] => @name || name(index))
		hash_fields.merge!(@fields[:sex] => @sex || sex(index))
		hash_fields.merge!(@fields[:birthdate] => {'start' => @birthdate || birthdate(index)})
		hash_fields.merge!(@fields[:phones] => @phones || phones(index))
		hash_fields.merge!(@fields[:emails] => @emails || emails(index))
		hash_fields.merge!(@fields[:zip_code] => @zip_code || zip_code(index))
		hash_fields.merge!(@fields[:city] => @city || city(index))
		hash_fields.merge!(@fields[:state] => @state_id || state_id(index))
		hash_fields.merge!(@fields[:study_stage] => @study_stage || study_stage(index))
    hash_fields.merge!(@fields[:university] => @university || university(index))
		hash_fields.merge!(@fields[:course] => @course || course(index))
		hash_fields.merge!(@fields[:semester] => @semester || semester(index))
		hash_fields.merge!(@fields[:graduation_year] => @graduation_year || graduation_year(index))
		hash_fields.merge!(@fields[:english_level] => @english_level || english_level(index))
		hash_fields.merge!(@fields[:spanish_level] => @spanish_level || spanish_level(index))
		hash_fields.merge!(@fields[:best_moment] => @best_moment || best_moment(index))
		hash_fields.merge!(@fields[:local_aiesec] => @local_aiesec_id || local_aiesec_id(index))
		hash_fields.merge!(@fields[:marketing_channel] => @marketing_channel || marketing_channel(index))
		hash_fields.merge!(@fields[:indication] => @indication || indication(index))
		hash_fields.merge!(@fields[:sync_with_local] => @sync_with_local || sync_with_local(index))
    hash_fields.merge!(@fields[:authorization] => @authorization || authorization(index))
    hash_fields.merge!(@fields[:id_local] => @id_local || id_local(index))
    hash_fields.merge!(@fields[:id_local_1] => @id_local_1 || id_local_1(index))
    hash_fields.merge!(@fields[:id_local_2] => @id_local_2 || id_local_2(index))
		hash_fields
	end

	def hashing_to_create
		hash_fields = {}
		hash_fields.merge!(@fields[:name] => @name) unless @name.nil?
		hash_fields.merge!(@fields[:sex] => @sex) unless @sex.nil?
		hash_fields.merge!(@fields[:birthdate] => {'start' => @birthdate}) unless @birthdate.nil?
		hash_fields.merge!(@fields[:phones] => @phones) unless @phones.nil?
		hash_fields.merge!(@fields[:emails] => @emails) unless @emails.nil?
		hash_fields.merge!(@fields[:zip_code] => @zip_code) unless @zip_code.nil?
		hash_fields.merge!(@fields[:city] => @city) unless @city.nil?
		hash_fields.merge!(@fields[:state] => @state_id) unless @state_id.nil?
		hash_fields.merge!(@fields[:study_stage] => @study_stage) unless @study_stage.nil?
    hash_fields.merge!(@fields[:university] => @university) unless @university.nil?
		hash_fields.merge!(@fields[:course] => @course) unless @course.nil?
		hash_fields.merge!(@fields[:semester] => @semester) unless @semester.nil?
    hash_fields.merge!(@fields[:graduation_year] => @graduation_year) unless @graduation_year.nil?
		hash_fields.merge!(@fields[:english_level] => @english_level) unless @english_level.nil?
		hash_fields.merge!(@fields[:spanish_level] => @spanish_level) unless @spanish_level.nil?
		hash_fields.merge!(@fields[:best_moment] => @best_moment) unless @best_moment.nil?
		hash_fields.merge!(@fields[:local_aiesec] => @local_aiesec_id) unless @local_aiesec_id.nil?
		hash_fields.merge!(@fields[:marketing_channel] => @marketing_channel) unless @marketing_channel.nil?
		hash_fields.merge!(@fields[:indication] => @indication) unless @indication.nil?
    hash_fields.merge!(@fields[:sync_with_local] => @sync_with_local) unless @sync_with_local.nil?
    hash_fields.merge!(@fields[:authorization] => @authorization) unless @authorization.nil?
    hash_fields.merge!(@fields[:id_local] => @id_local) unless @id_local.nil?
    hash_fields.merge!(@fields[:id_local_1] => @id_local_1) unless @id_local_1.nil?
    hash_fields.merge!(@fields[:id_local_2] => @id_local_2) unless @id_local_2.nil?
		hash_fields
  end

	# Update register on Podio database
	# @param index [Integer] Index of the item you want to retrieve the value
	def update(index)
		Podio::Item.update(item_id(index), { :fields => hashing_to_update(index) })
	end

	# Create register on Podio database
	# @param index [Integer] Index of the item you want to retrieve the value
	def create
		Podio::Item.create(@app_id, { :fields => hashing_to_create })
	end

	# delete register on Podio database
	# @param index [Integer] Index of the item you want to delete the value
	def delete(index)
		Podio::Item.delete(item_id(index))
	end
end