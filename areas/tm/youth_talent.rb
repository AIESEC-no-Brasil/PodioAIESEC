require_relative '../../utils/youth_leader'

# Generic App at tm workspaces
# @author Luan Corumba <luan.corumba@aiesec.net>
class YouthTalent < YouthLeader

  date_attr_accessor :first_contact_date, :dynamics_date, :interview_date
  boolean_attr_accessor :vacation_volunteer, :interview_result, :intervield, :specific_opportunity, :was_in_dynamics
  reference_attr_accessor :responsable

	def initialize(app_id)
		fields = {
        :vacation_volunteer => 'voce-esta-se-inscrevendo-para-o-programa-de-trabalho-vo',
        :specific_opportunity => 'caso-voce-esta-se-candidatando-a-algum-projetovaga-espe',
        :responsable => 'responsavel-pelo-primeiro-contato',
        :first_contact_date => 'data-do-primeiro-contato',
        :dynamics_date => 'data-da-dinamica',
        :was_in_dynamics => 'compareceu-a-dinamica',
        :intervield => 'foi-entrevistado',
        :interview_date => 'data-da-entrevista',
        :interview_result => 'virou-membro'
		}
		super(app_id, fields)
	end

	# Populate self variables with the values of another app
	# @param other [YouthTalent] Reference of the other app
	# @param i [Integer] Index of the item you want to retrieve the value
	def populate(other,i)
    super(other,i)
    self.vacation_volunteer=(other.vacation_volunteer(i))
    self.specific_opportunity=(other.specific_opportunity(i))
    self.responsable=(other.responsable(i))
    self.first_contact_date=(other.first_contact_date(i))
    self.dynamics_date=(other.dynamics_date(i))
    self.was_in_dynamics=(other.was_in_dynamics(i))
    self.intervield=(other.intervield(i))
    self.interview_date=(other.interview_date(i))
    self.interview_result=(other.interview_result(i))
	end

	def can_be_local?(i, entity)
		true unless sync_with_local?(i)
	end

	def can_be_contacted?(i)
		true unless first_contact_date(i).nil?
	end

	def can_be_dynamics?(i)
		true unless dynamics_date(i).nil?
	end

	def can_be_interviewed?(i)
		true unless not was_in_dynamics?(i) or interview_date(i).nil?
	end

	def can_be_member?(i)
		interview_result?(i)
  end

  private

  def hashing
    hash_fields = super
    hash_fields.merge!(@fields[:vacation_volunteer] => @vacation_volunteer) unless @vacation_volunteer.nil?
    hash_fields.merge!(@fields[:specific_opportunity] => @specific_opportunity) unless @specific_opportunity.nil?
    hash_fields.merge!(@fields[:responsable] => @responsable) unless @responsable.nil?
    hash_fields.merge!(@fields[:first_contact_date] => {'start' => @first_contact_date}) unless @first_contact_date.nil?
    hash_fields.merge!(@fields[:dynamics_date] => {'start' => @dynamics_date}) unless @dynamics_date.nil?
    hash_fields.merge!(@fields[:was_in_dynamics] => @was_in_dynamics) unless @was_in_dynamics.nil?
    hash_fields.merge!(@fields[:intervield] => @intervield) unless @intervield.nil?
    hash_fields.merge!(@fields[:interview_date] => {'start' => @interview_date}) unless @interview_date.nil?
    hash_fields.merge!(@fields[:interview_result] => @interview_result) unless @interview_result.nil?
    hash_fields
  end
end