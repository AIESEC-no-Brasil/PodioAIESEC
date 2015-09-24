require_relative '../../utils/youth_leader'

# Generic App at tm workspaces
# @author Luan Corumba <luan.corumba@aiesec.net>
class YouthTalent < YouthLeader

  boolean_attr_accessor :send_to_selection, :stop_approach, :send_to_rapproachement, :join_selection, :was_selected
  boolean_attr_accessor :has_volunteer_term, :has_organizational_induction, :has_functional_induction, :had_internship
  category_attr_accessor :rapprochement_notes, :rapprochement_reason, :approach_interruption_reason
  category_attr_accessor :approach_channel, :selection_type, :current_position, :status, :leave_reason
  date_attr_accessor :organizational_induction_date, :functional_induction_date, :leave_date
  date_attr_accessor :first_approach_date, :selection_date, :next_contact_date
  reference_attr_accessor :responsable, :responsable_new_contact, :area
  number_attr_accessor :approaches_number
  text_attr_accessor :feedback, :position_history, :internship_history
  link_attr_accessor :facebook, :linkedin

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
        :functional_induction_date => 'data-da-inducao-funcional',
        :approach_channel => 'canal-de-comunicacao-utilizado-no-primeiro-contato',
        :facebook => 'facebook-profile',
        :linkedin => 'linkedin-profile',
        :area => 'area',
        :current_position => 'cargo-atual',
        :position_history => 'historico-de-cargos',
        :had_internship => 'ja-realizou-um-intercambio-pela-aiesec',
        :internship_history => 'se-sim-especifique-pais-duracao-mesano-de-conclusao',
        :status => 'status',
        :leave_date => 'data-de-saida',
        :leave_reason => 'motivo-de-saisa'
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
    self.approach_channel=(other.approach_channel(i))
    self.facebook=(other.facebook(i))
    self.linkedin=(other.linkedin(i))
    self.area=(other.area(i))
    self.current_position=(other.current_position(i))
    self.position_history=(other.position_history(i))
    self.had_internship=(other.had_internship(i))
    self.internship_history=(other.internship_history(i))
    self.status=(other.status(i))
    self.leave_date=(other.leave_date(i))
    self.leave_reason=(other.leave_reason(i))
	end

	def business_rule_ors_to_local_lead?(i, entity)
		true unless sync_with_local?(i) && local_aiesec(i) == entity
	end

	def business_rule_lead_to_approach?(i)
		true unless first_approach_date(i).nil? && responsable(i).nil? && approach_channel(i).nil?
  end

  def business_rule_approach_to_rapproach?(i)
    true unless !send_to_rapproachement?(i) && rapprochement_notes(i).nil? && rapprochement_reason(i).nil?
  end

  def business_rule_stop_rapproach?(i)
    true unless !stop_approach?(i) && approach_interruption_reason(i).nil?
  end

  def business_rule_rapproach_to_selection?(i)
    true unless !send_to_selection?(i) && responsable_new_contact(i).ni?
  end

	def business_rule_approach_to_selection?(i)
		true unless selection_date(i).nil?
  end

  def business_rule_selection_to_rapproach?(i)
    true unless !send_to_rapproachement?(i) && join_selection?(i)
  end

  def business_rule_delete_selection?(i)
    true unless was_selected?(i) && feedback(i).nil?
  end

	def business_rule_selection_to_induction?(i)
    true unless !join_selection?(i) && selection_type(i).nil?
  end

	def business_rule_induction_to_local_crm?(i)
    true unless !has_volunteer_term?(i) && !has_functional_induction?(i) && !has_organizational_induction?(i) && organizational_induction_date(i).nil? && functional_induction_date(i).nil?
  end

  def hashing
    hash_fields = super
    hash_fields.merge!(@fields[:responsable] => @responsable) unless @responsable.nil?
    hash_fields.merge!(@fields[:first_approach_date] => {'start' => @first_approach_date}) unless @first_approach_date.nil?
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
    hash_fields.merge!(@fields[:approach_channel] => @approach_channel) unless @approach_channel.nil?
    hash_fields.merge!(@fields[:facebook] => @facebook) unless @facebook.nil?
    hash_fields.merge!(@fields[:linkedin] => @linkedin) unless @linkedin.nil?
    hash_fields.merge!(@fields[:area] => @area) unless @area.nil?
    hash_fields.merge!(@fields[:current_position] => @current_position) unless @current_position.nil?
    hash_fields.merge!(@fields[:position_history] => @position_history) unless @position_history.blank?
    hash_fields.merge!(@fields[:had_internship] => @had_internship) unless @had_internship.nil?
    hash_fields.merge!(@fields[:internship_history] => @internship_history) unless @internship_history.blank?
    hash_fields.merge!(@fields[:status] => @status) unless @status.nil?
    hash_fields.merge!(@fields[:leave_date] => @leave_date) unless @leave_date.nil?
    hash_fields.merge!(@fields[:leave_reason] => @leave_reason) unless @leave_reason.nil?
    hash_fields
  end
end