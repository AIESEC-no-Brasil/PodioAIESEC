require_relative '../control/podio_app_control'
require_relative '../enums'
require_relative 'utils'

class YouthLeader < PodioAppControl

  text_attr_accessor :name, :address, :city, :course, :university, :indication
  number_attr_accessor :zip_code
  date_attr_accessor :birthdate
  boolean_attr_accessor :erase, :sync_with_local
  category_attr_accessor :sex, :study_stage, :semester, :english_level, :spanish_level, :best_moment
  category_attr_accessor :marketing_channel, :carrier
  multiple_attr_accessor :phones, :emails
  reference_attr_accessor :state, :local_aiesec

  def initialize(app_id, extra_fields)
    basic_fields = {
        :name => 'titulo',
        :sex => 'sexo',
        :birthdate => 'data-de-nascimento',
        :phones => 'telefone',
        :telefone_old => 'telefone-3',#TODO exluir
        :celular => 'celular-2',#TODO exluir
        :carrier => 'operadoras', #TODO aceitar múltiplas
        :emails => 'email',
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
        :marketing_channel => 'categoria',
        :indication => 'nome-da-pessoaentidade-que-lhe-indicou',
        :erase => 'apagar',
        :sync_with_local => 'transferido-para-area-local'
    }
    basic_fields.merge!(extra_fields) unless extra_fields.nil?
    super(app_id, basic_fields)
  end

  # Populate self variables with the values of intervield fields
  # @param member [YouthLeader] Reference to another member
  # @param i [Integer] Index of the item you want to retrieve the value
  def populate(other,i)
    self.name=(other.name(i))
    self.sex=(other.sex(i))
    self.birthdate=(other.birthdate(i))
    self.phones=(other.phones(i))
    self.carrier=(other.carrier(i))
    self.emails=(other.emails(i))
    self.address=(other.address(i))
    self.zip_code=(other.zip_code(i))
    self.city=(other.city(i))
    self.state=(other.state(i))
    self.study_stage=(other.study_stage(i))
    self.course=(other.course(i))
    self.semester=(other.semester(i))
    self.university=(other.university(i))
    self.english_level=(other.english_level(i))
    self.spanish_level=(other.spanish_level(i))
    self.best_moment=(other.best_moment(i))
    self.local_aiesec=(other.local_aiesec(i))
    self.marketing_channel=(other.marketing_channel(i))
    self.indication=(other.indication(i))
    self.erase=(other.erase(i))
  end

  # Update register on Podio database
  # @param index [Integer] Index of the item you want to retrieve
  def update(index)
    Podio::Item.update(item_id(index), { :fields => hashing })
  end

  # Create register on Podio database
  def create
    Podio::Item.create(@app_id, { :fields => hashing })
  end

  # delete register on Podio database
  # @param index [Integer] Index of the item you want to delete
  def delete(index)
    Podio::Item.delete(item_id(index))
  end

  private

  def hashing
    hash_fields = {}
    hash_fields.merge!(@fields[:name] => @name) unless @name.nil?
    hash_fields.merge!(@fields[:sex] => @sex) unless @sex.nil?
    hash_fields.merge!(@fields[:birthdate] => {'start' => @birthdate}) unless @birthdate.nil?
    hash_fields.merge!(@fields[:phones] => @phones) unless @phones.nil?
    #hash_fields.merge!(@fields[:telefone_old] => @telefone) unless @telefone.nil?
    #hash_fields.merge!(@fields[:celular] => @celular) unless @celular.nil?
    hash_fields.merge!(@fields[:carrier] => @carrier) unless @carrier.nil?
    hash_fields.merge!(@fields[:emails] => @emails) unless @emails.nil?
    #hash_fields.merge!(@fields[:email_old] => @email_text) unless @email_text.nil?
    hash_fields.merge!(@fields[:address] => @address) unless @address.nil?
    hash_fields.merge!(@fields[:zip_code] => @zip_code) unless @zip_code.nil?
    hash_fields.merge!(@fields[:city] => @city) unless @city.nil?
    hash_fields.merge!(@fields[:state] => @state) unless @state.nil?
    hash_fields.merge!(@fields[:study_stage] => @study_stage) unless @study_stage.nil?
    hash_fields.merge!(@fields[:course] => @course) unless @course.nil?
    hash_fields.merge!(@fields[:semester] => @semester) unless @semester.nil?
    hash_fields.merge!(@fields[:university] => @university) unless @university.nil?
    hash_fields.merge!(@fields[:english_level] => @english_level) unless @english_level.nil?
    hash_fields.merge!(@fields[:spanish_level] => @spanish_level) unless @spanish_level.nil?
    hash_fields.merge!(@fields[:best_moment] => @best_moment) unless @best_moment.nil?
    hash_fields.merge!(@fields[:local_aiesec] => @local_aiesec) unless @local_aiesec.nil?
    hash_fields.merge!(@fields[:marketing_channel] => @marketing_channel) unless @marketing_channel.nil?
    hash_fields.merge!(@fields[:indication] => @indication) unless @indication.nil?
    hash_fields.merge!(@fields[:erase] => @erase) unless @erase.nil?
    hash_fields
  end

end