require_relative '../../utils/youth_leader_dao'

# Generic App at ogip workspaces
# @author Luan Corumba <luan.corumba@aiesec.net>
class GlobalCitizenDAO < YouthLeaderDAO

	def initialize(app_id)
		fields = {
				:name => 'nome', #ops
				:birthdate => 'data-de-nascimento-2', #ops
				:phones => 'telefone-2', #ops
				:study_stage => 'formacao2', #ops
				:best_moment => 'melhor-turno-test', #ops
				:local_aiesec => 'aiesec-mais-proxima2', #ops
				:address => 'endereco2', #ops
        :state => 'estado2', #ops
        :university => 'universidade', #ops
        :other_university => 'se-voce-selecionou-a-opcao-outras-especifique-aqui-a-su',
        :course => 'curso-2', #ops
        :semester => 'semestre-3', #ops
        :marketing_channel => 'como-voce-conheceu-a-aiesec', #ops
				:interest => 'programa-de-interesse2',
				:specific_opportunity => 'caso-voce-esta-se-candidatando-a-algum-projetovaga-espe',
				:cv => 'cv',
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
				:ops_date => 'data-da-ops',
				:was_in_ops => 'compareceu-a-ops',
				:match_date => 'data-do-match',
				:country_host => 'pais-de-destino',
				:lc_host => 'comite-de-destino',
				:realize_date => 'data-do-realize', #TODO considerar início e fim
				:complete_date => 'data-do-complete',
				:join_ris => 'compareceu-aos-ris',
				:erase => 'apagar'
		}
		super(app_id, fields)
	end

	def find_with_date_in(field)
		create_models Podio::Item.find_by_filter_values(@app_id, {@fields_name_map[field][:id] => {'from'=>'1900-01-01 00:00:00'}}, :sort_by => 'created_on').all
	end

	def can_be_contacted?(global_citizen)
		true unless global_citizen.first_approach_date.nil? &&
				global_citizen.first_contact_responsable.nil? &&
				!say_yes?(global_citizen.approach_result) &&
				global_citizen.approach_channel.nil?
	end

	def can_be_EPI?(global_citizen)
		true unless global_citizen.epi_date.nil? &&
				global_citizen.epi_responsable.nil?
	end

	def can_be_open?(global_citizen)
		#TODO verificar se o link é realmente do expa. Usar include? para string
		true unless global_citizen.link_to_expa.nil? &&
				global_citizen.ep_manager.nil?
	end

	def can_be_ip?(global_citizen)
		say_yes?(global_citizen.applying)
	end

	def can_be_ma?(global_citizen)
		true unless global_citizen.match_date.nil? &&
				global_citizen.country_host.nil? &&
				global_citizen.lc_host.nil?
	end

	def can_be_re?(global_citizen)
		true unless global_citizen.ops_date.nil? &&
				global_citizen.realize_date.nil?
	end

	def can_be_co?(global_citizen)
		true unless global_citizen.complete_date.nil?
	end
end