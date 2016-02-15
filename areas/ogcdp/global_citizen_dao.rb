require_relative '../../utils/youth_leader_dao'

# Generic App at ogip workspaces
# @author Luan Corumba <luan.corumba@aiesec.net>
class GlobalCitizenDAO < YouthLeaderDAO

	def initialize(app_id)
		fields = {
        :priority => 'prioridade',
        :duplicate_vp => 'vp-dobrado',
        :first_approach_date => 'data-do-primeiro-contato',
        :first_contact_responsable => 'responsavel-pelo-primeiro-contato',
        :approach_channel => 'qual-canal-de-abordagem-foi-utilizado',
        :approach_description => 'descricao-da-abordagem',
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
        :join_ris => 'compareceu-aos-ris'
		}
		super(app_id, fields)
	end

	def can_be_contacted?(global_citizen)
    begin
      true unless global_citizen.first_approach_date.nil? ||
          global_citizen.first_contact_responsable.nil? ||
          global_citizen.approach_channel.nil?
    rescue => exception
      puts exception.to_s
    end
	end

	def can_be_EPI?(global_citizen)
    begin
      true unless global_citizen.epi_date.nil? ||
          global_citizen.epi_responsable.nil?
    rescue => exception
      puts exception.to_s
    end
	end

	def can_be_open?(global_citizen)
		#TODO verificar se o link é realmente do expa. Usar include? para string
    begin
      true unless global_citizen.link_to_expa.nil? ||
          global_citizen.ep_manager.nil?
    rescue => exception
      puts exception.to_s
    end
	end

	def can_be_ip?(global_citizen)
    begin
      say_yes?(global_citizen.applying)
    rescue => exception
      puts exception.to_s
    end
	end

	def can_be_ma?(global_citizen)
    begin
      true unless global_citizen.match_date.nil? ||
          global_citizen.country_host.nil? ||
          global_citizen.lc_host.nil?
    rescue => exception
      puts exception.to_s
    end
	end

	def can_be_re?(global_citizen)
    begin
      true unless global_citizen.ops_date.nil? ||
          global_citizen.realize_date.nil?
    rescue => exception
      puts exception.to_s
    end
	end

	def can_be_co?(global_citizen)
    begin
      true unless global_citizen.complete_date.nil?
    rescue => exception
      puts exception.to_s
    end
  end
end