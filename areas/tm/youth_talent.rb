require_relative '../../utils/youth_leader'

# Generic App at tm workspaces
# @author Luan Corumba <luan.corumba@aiesec.net>
class YouthTalent < YouthLeader

  category_attr_accessor :rapprochement_notes, :rapprochement_reason, :approach_interruption_reason, :selection_type
  boolean_attr_accessor :send_to_selection, :stop_approach, :send_to_rapproachement, :join_selection, :was_selected
  boolean_attr_accessor :has_volunteer_term, :has_organizational_induction, :has_functional_induction
  date_attr_accessor :organizational_induction_date, :functional_induction_date
  date_attr_accessor :first_approach_date, :selection_date, :next_contact_date
  reference_attr_accessor :responsable, :responsable_new_contact
  number_attr_accessor :approaches_number
  text_attr_accessor :feedback

	def initialize(app_id)
		fields = {
        :responsable => 'responsavel-pelo-primeiro-contato',
        :first_approach_date => 'data-do-primeiro-contato',
        :selection_date => 'data-da-selecao',
        :next_contact_date => 'data-da-proxima-abordagem',
        :rapprochement_notes => 'anotacoes-sobre-abordagem',
        :rapprochement_reason => 'motivo-da-reabordagem',
        :send_to_selection => 'inscrito-foi-abordado-deve-ir-para-selecao',
        :responsable_new_contact => 'responsavel-pelo-novo-contato',
        :stop_approach => 'parar-de-abordar-inscrito',
        :approach_interruption_reason => 'motivo_da_interrupcao-da-abordagem',
        :approaches_number => 'numero-de-tentativas-de-abordagem',
        :send_to_rapproachement => 'deve-ser-encaminhado-para-reabordagem',
        :join_selection => 'compareceu-a-selecao',
        :selection_type => 'tipo-de-selecao',
        :was_selected => 'foi-selecionado',
        :feedback => 'feedback',

        :has_volunteer_term => 'termo-de-voluntariado',
        :has_organizational_induction => 'inducao-organizacional',
        :has_functional_induction => 'inducao-funcional',
        :organizational_induction_date => 'data-da-inducao-organizacional',
        :functional_induction_date => 'data-da-inducao-funcional'
		}
		super(app_id, fields)
	end

	# Populate self variables with the values of another app
	# @param other [YouthTalent] Reference of the other app
	# @param i [Integer] Index of the item you want to retrieve the value
	def populate(other,i)
    super(other,i)
    self.responsable=(other.responsable(i))
    self.first_approach_date=(other.first_approach_date(i))
    self.selection_date=(other.selection_date(i))
    self.next_contact_date=(other.next_contact_date(i))
    self.rapprochement_notes=(other.rapprochement_notes(i))
    self.rapprochement_reason=(other.rapprochement_reason(i))
    self.send_to_selection=(other.send_to_selection(i))
    self.responsable_new_contact=(other.responsable_new_contact(i))
    self.stop_approach=(other.stop_approach(i))
    self.approach_interruption_reason=(other.approach_interruption_reason(i))
    self.approaches_number=(other.approaches_number(i))
    self.send_to_rapproachement=(other.send_to_rapproachement(i))
    self.join_selection=(other.join_selection(i))
    self.selection_type=(other.selection_type(i))
    self.was_selected=(other.was_selected(i))
    self.feedback=(other.feedback(i))
    self.has_volunteer_term=(other.has_volunteer_term(i))
    self.has_organizational_induction=(other.has_organizational_induction(i))
    self.has_functional_induction=(other.has_functional_induction(i))
    self.organizational_induction_date=(other.organizational_induction_date(i))
    self.functional_induction_date=(other.functional_induction_date(i))
	end

	def business_rule_ors_to_local_lead?(i, entity)
		true unless sync_with_local?(i) && local_aiesec(i) == entity
	end

	def business_rule_lead_to_approach?(i)
		true unless first_approach_date(i).nil?
  end

  def business_rule_approach_to_rapproach?(i)
    true unless send_to_rapproachement?(i) && rapprochement_notes(i).nil? && rapprochement_reason(i).nil?
  end

  def business_rule_stop_rapproach?(i)
    true unless stop_approach?(i) && approach_interruption_reason(i).nil?
  end

  def business_rule_rapproach_to_selection?(i)
    true unless responsable_new_contact(i).ni? && send_to_selection?(i)
  end

	def business_rule_approach_to_selection?(i)
		true unless selection_date(i).nil?
  end


  def business_rule_selection_to_rapproach?(i)
    true unless not join_selection?(i) && send_to_rapproachement?(i)
  end

  def business_rule_delete_selection?(i)
    true unless as_selected?(i) && feedback(i).nil?
  end

	def business_rule_selection_to_induction?(i)
    true unless join_selection?(i) && selection_type(i).nil?
  end

	def business_rule_induction_to_local_crm?(i)
    true unless has_volunteer_term?(i) && has_functional_induction?(i) && has_organizational_induction?(i) && organizational_induction_date(i).nil? && functional_induction_date(i).nil?
  end

  private

  def hashing
    hash_fields = super
    hash_fields.merge!(@fields[:responsable] => @responsable) unless @responsable.nil?
    hash_fields.merge!(@fields[:first_approach_date] => {'start' => @first_contact_date}) unless @first_contact_date.nil?
    hash_fields.merge!(@fields[:selection_date] => {'start' => @selection_date}) unless @selection_date.nil?
    hash_fields.merge!(@fields[:next_contact_date] => @next_contact_date) unless @next_contact_date.nil?
    hash_fields.merge!(@fields[:rapprochement_notes] => @rapprochement_notes) unless @rapprochement_notes.nil?
    hash_fields.merge!(@fields[:rapprochement_reason] => @rapprochement_reason) unless @rapprochement_reason.nil?
    hash_fields.merge!(@fields[:send_to_selection] => @send_to_selection) unless @send_to_selection.nil?
    hash_fields.merge!(@fields[:responsable_new_contact] => @responsable_new_contact) unless @responsable_new_contact.nil?
    hash_fields.merge!(@fields[:stop_approach] => @stop_approach) unless @stop_approach.nil?
    hash_fields.merge!(@fields[:approach_interruption_reason] => @approach_interruption_reason) unless @approach_interruption_reason.nil?
    hash_fields.merge!(@fields[:approaches_number] => @approaches_number) unless @approaches_number.nil?
    hash_fields.merge!(@fields[:send_to_rapproachement] => @send_to_rapproachement) unless @send_to_rapproachement.nil?
    hash_fields.merge!(@fields[:join_selection] => @join_selection) unless @join_selection.nil?
    hash_fields.merge!(@fields[:selection_type] => @selection_type) unless @selection_type.nil?
    hash_fields.merge!(@fields[:was_selected] => @was_selected) unless @was_selected.nil?
    hash_fields.merge!(@fields[:feedback] => @feedback) unless @feedback.blank?
    hash_fields.merge!(@fields[:has_volunteer_term] => @has_volunteer_term) unless @has_volunteer_term.nil?
    hash_fields.merge!(@fields[:has_organizational_induction] => @has_organizational_induction) unless @has_organizational_induction.nil?
    hash_fields.merge!(@fields[:has_functional_induction] => @has_functional_induction) unless @has_functional_induction.nil?
    hash_fields.merge!(@fields[:organizational_induction_date] => @organizational_induction_date) unless @organizational_induction_date.nil?
    hash_fields.merge!(@fields[:functional_induction_date] => @functional_induction_date) unless @functional_induction_date.nil?
    hash_fields
  end
end