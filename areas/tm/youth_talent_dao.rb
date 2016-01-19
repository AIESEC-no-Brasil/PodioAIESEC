require_relative '../../utils/youth_leader_dao'

# Generic App at ogip workspaces
# @author Luan Corumba <luan.corumba@aiesec.net>
class YouthTalentDAO < YouthLeaderDAO

    def initialize(app_id)
        fields = {
            :first_approach_date => 'data-do-primeiro-contato',
            :responsable => 'responsavel-pelo-primeiro-contato',
            :approach_channel => 'canal-de-comunicacao-utilizado-no-primeiro-contato',
            :selection_date => 'data-da-selecao',
            :selection_type => 'tipo-de-selecao',
            :has_volunteer_term => 'termo-de-voluntariado',
            :organizational_induction_date => 'data-da-inducao-organizacional',
            :functional_induction_date => 'data-da-inducao-funcional',
            :facebook => 'facebook-profile',
            :linkedin => 'linkedin-profile',
            :area => 'area',
            :current_position => 'cargo-atual',
            :position_history => 'historico-de-cargos',
            :had_internship => 'ja-realizou-um-intercambio-pela-aiesec',
            :status => 'status',
            :leave_date => 'data-de-saida',
            :leave_reason => 'motivo-de-saida',
            :next_contact_date => 'data-da-proxima-abordagem',
            :rapprochement_notes => 'anotacoes-sobre-reabordagem',
            :rapprochement_reason => 'motivo-da-reabordagem',
            :send_to_selection => 'inscrito-foi-abordado-deve-ir-para-selecao',
            :responsable_new_contact => 'responsavel-pelo-novo-contato',
            :stop_approach => 'parar-de-abordar-inscrito',
            :approach_interruption_reason => 'motivo-da-interrupcao-da-abordagem',
            :approaches_number => 'numero-de-tentativas-de-abordagem',
            :send_to_rapproachement => 'deve-ser-encaminhado-para-reabordagem',
            :was_selected => 'foi-selecionado',
            :feedback => 'feedback',
            :join_selection => 'compareceu-a-selecao',
            :has_organizational_induction => 'inducao-organizacional',
            :has_functional_induction => 'inducao-funcional',
            :internship_history => 'se-sim-especifique-pais-duracao-mesano-de-conclusao'

        }
        super(app_id, fields)
    end

    def find_with_date_in(field)
        create_models Podio::Item.find_by_filter_values(@app_id, {@fields_name_map[field][:id] => {'from'=>'1900-01-01 00:00:00'}}, :sort_by => 'created_on').all
    end

    def business_rule_lead_to_approach?(youth_talent)
        true unless youth_talent.first_approach_date.nil? ||
            youth_talent.responsable.nil? ||
            youth_talent.approach_channel.nil?
    end

    def business_rule_approach_to_rapproach?(youth_talent)
        true unless !say_yes?(youth_talent.send_to_rapproachement) ||
            youth_talent.rapprochement_notes.nil? ||
            youth_talent.rapprochement_reason.nil?
    end

    def business_rule_stop_rapproach?(youth_talent)
        true unless !say_yes?(youth_talent.stop_approach) ||
            youth_talent.approach_interruption_reason.nil?
    end

    def business_rule_rapproach_to_selection?(youth_talent)
        true unless !say_yes?(youth_talent.send_to_selection) ||
            youth_talent.responsable_new_contact.nil?
    end

    def business_rule_approach_to_selection?(youth_talent)
        true unless youth_talent.selection_date.nil?
    end

    def business_rule_selection_to_rapproach?(youth_talent)
        true unless !say_yes?(youth_talent.send_to_rapproachement) ||
            !say_yes?(youth_talent.join_selection)
    end

    def business_rule_delete_selection?(youth_talent)
        true unless !say_yes?(youth_talent.was_selected) ||
            youth_talent.feedback.nil?
    end

    def business_rule_selection_to_induction?(youth_talent)
        true unless !say_yes?(youth_talent.join_selection) ||
            !say_yes?(youth_talent.was_selected) ||
            youth_talent.selection_type.nil?
    end

    def business_rule_induction_to_local_crm?(youth_talent)
        true unless !say_yes?(youth_talent.has_volunteer_term) ||
            !say_yes?(youth_talent.has_functional_induction) ||
            !say_yes?(youth_talent.has_organizational_induction) ||
            youth_talent.organizational_induction_date.nil? ||
            youth_talent.functional_induction_date.nil?
    end
end