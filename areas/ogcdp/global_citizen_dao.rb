require_relative '../../utils/youth_leader_dao'

# Generic App at ogip workspaces
# @author Luan Corumba <luan.corumba@aiesec.net>
class GlobalCitizenDAO < YouthLeaderDAO

	def initialize(app_id)
		fields = {
			:interest => 'programa-de-intersesse',
			:specific_opportunity => 'esta-se-candidatando-a-algum-projetovaga-especifica',
			:cv => 'cv',
			:priority => 'prioridade',
			:first_approach_date => 'data-do-primeiro-contato',
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

	def find_with_date_in(field)
        create_models Podio::Item.find_by_filter_values(@app_id, {@fields_name_map[field][:id] => {'from'=>'1900-01-01 00:00:00'}}, :sort_by => 'created_on').all
    end

	def can_be_contacted?(global_citizen)
		true unless global_citizen.first_approach_date.nil? or global_citizen.first_contact_responsable.nil?
	end

	def can_be_EPI?(global_citizen)
		true unless global_citizen.epi_date.nil? or global_citizen.epi_responsable.nil?
	end

	def can_be_open?(global_citizen)
		true unless global_citizen.link_to_expa.nil? or global_citizen.ep_manager.nil?
	end

	def can_be_ip?(global_citizen)
		global_citizen.applying == 2
	end

	def can_be_ma?(global_citizen)
		true unless global_citizen.match_date.nil?
	end

	def can_be_re?(global_citizen)
		true unless global_citizen.ops_date.nil? or global_citizen.realize_date.nil?
	end
end