require_relative '../control/podio_app_control'
require_relative '../control/youth_leader'
require_relative '../enums'

# Generic App at oGIP workspaces
# @author Luan Corumba <luan.corumba@aiesec.net>
class GlobalTalent < YouthLeader

	date_attr_accessor :first_contact_date, :epi_date, :match_date, :realize_date, :ops_date
	boolean_attr_accessor :applying, :was_in_ops, :specific_opportunity, :erase
	category_attr_accessor :interest, :priority
	reference_attr_accessor :first_contact_responsable, :epi_responsable, :ep_manager
	link_attr_accessor :link_to_expa
	#img_attr_accessor :cv #TODO

	def initialize(app_id)
		fields = {
			:interest => 'programa-de-intersesse',
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
		}
		super(app_id, fields)
	end

	# Populate self variables with the values of intervield fields
	# @param entrevistado [App4Entrevistado] Reference of the intervield other
	# @param i [Integer] Index of the item you want to retrieve the value
	def populate(other,i)
		super(other,i)
		self.interest = other.interest i
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
	end

	def hashing_to_update(index)
		hash_fields = super(index)
		hash_fields.merge!(@fields[:interest] => @interest || interest(index))
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
		hash_fields
	end

	def hashing_to_create
		hash_fields = super
		hash_fields.merge!(@fields[:interest] => @interest) unless @interest.nil?
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
		hash_fields
	end

	def can_be_local?(i)
		true
	end

	def can_be_contacted?(i)
		true unless self.first_contact_date(i).nil? or self.first_contact_responsable_id(i).nil?
	end

	def can_be_EPI?(i)
		true unless self.epi_date(i).nil? or self.epi_responsable_id(i).nil?
	end

	def can_be_open?(i)
		true unless self.link_to_expa(i).nil? or self.ep_manager_id(i).nil?
	end

	def can_be_ip?(i)
		self.applying?(i)
	end

	def can_be_ma?(i)
		true unless self.match_date(i).nil?
	end

	def can_be_re?(i)
		true unless self.ops_date(i).nil? or self.realize_date(i).nil?
	end
end