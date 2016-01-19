require_relative '../../utils/youth_leader_dao'

# Generic App at ogip workspaces
# @author Luan Corumba <luan.corumba@aiesec.net>
class GlobalTalentDAO < YouthLeaderDAO

	def initialize(app_id)
		fields = {
      :priority => 'prioridade',
      :first_approach_date => 'data-do-primeiro-contato',
      :first_contact_responsable => 'responsavel-pelo-primeiro-contato',
      :approach_channel => 'qual-canal-de-abordagem-foi-utilizado',
      :approach_description => 'descricao-da-abordagem',
      :approach_result => 'foi-abordado-e-nao-respondeu',
      :epi_date => 'data-da-epi',
      :epi_responsable => 'responsavel-pelo-epi',
      :ep_manager => 'ep-manager',
      :link_to_expa => 'link-do-perfil-no-expa',
      :countries_options => 'paises-interessados',
      :applying => 'comecou-a-se-aplicar',
      :match_date => 'data-do-match',
      :country_host => 'pais-de-destino',
      :lc_host => 'comite-de-destino',
      :realize_date => 'data-do-realize', #TODO considerar início e fim
      :ops_date => 'data-da-ops',
      :was_in_ops => 'compareceu-a-ops',
      :complete_date => 'data-do-complete',
      :join_ris => 'compareceu-aos-ris',
      :sub_product => 'sub-produto',
      :duplicate_vp => 'vp-dobrado'
		}
		super(app_id, fields)
	end

	def find_with_date_in(field)
        create_models Podio::Item.find_by_filter_values(@app_id, {@fields_name_map[field][:id] => {'from'=>'1900-01-01 00:00:00'}}, :sort_by => 'created_on').all
    end

	def can_be_contacted?(global_talent)
		true unless global_talent.first_approach_date.nil? ||
				global_talent.first_contact_responsable.nil? ||
				!say_yes?(global_talent.approach_result) ||
				global_talent.approach_channel.nil?
	end

	def can_be_EPI?(global_talent)
		true unless global_talent.epi_date.nil? ||
				global_talent.epi_responsable.nil?
	end

	def can_be_open?(global_talent)
		#TODO verificar se o link é realmente do expa. Usar include? para string
		true unless global_talent.link_to_expa.nil? ||
				global_talent.ep_manager.nil?
	end

	def can_be_ip?(global_talent)
		say_yes?(global_talent.applying)
	end

	def can_be_ma?(global_talent)
		true unless global_talent.match_date.nil? ||
				global_talent.country_host.nil? ||
				global_talent.lc_host.nil? ||
				global_talent.sub_product.nil?
	end

	def can_be_re?(global_talent)
		true unless global_talent.ops_date.nil? ||
				global_talent.realize_date.nil? ||
				!say_yes?(global_talent.was_in_ops)
  end

  def can_be_co?(global_talent)
    true unless global_talent.complete_date.nil? ||
				!say_yes(global_talent.join_ris)
  end
end