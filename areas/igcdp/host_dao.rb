require_relative '../../control/podio_app_control'

# Generic App at ogip workspaces
# @author Luan Corumba <luan.corumba@aiesec.net>
class HostDAO < PodioAppControl

	def initialize(app_id)
		fields = {
			:name => 'titulo',
            :sex => 'sexo',
            :birthdate => 'data-de-nascimento',
            :phones => 'telefone',
            :telefone_old => 'telefone-3',#TODO exluir
            :celular => 'celular-2',#TODO exluir
            :carrier => 'operadoras',
            :emails => 'email',
            :email_old => 'email-2',#TODO exluir
            :address => 'endereco-completo',
            :zip_code => 'cep',
            :city => 'cidade',
            :state => 'estado',
            :course => 'texto',
            :type_of_host => 'receberem-em',
            :first_time => 'primeira-vez-como-host',
            :quantity_available => 'quantos-intercambistas-pretende-receber',
            :max_time_of_xp => 'tempo-maximo-que-pretende-ser-host',
            :best_moment => 'melhor-turno-para-a-aiesec-entrar-em-contato',
            :local_aiesec => 'aiesec-mais-proxima',
            :marketing_channel => 'categoria',
            :indication => 'nome-da-pessoaentidade-que-lhe-indicou',
            :erase => 'apagar',
            :sync_with_local => 'transferido-para-area-local',
            :lead_date => 'data-da-inscricao',
            :first_contact_date => 'data-do-primeiro-contato',
            :first_contact_responsable => 'responsavel-pelo-primeiro-contato',
            :communication_channel => 'canal-de-comunicacao-utilizado',
            :re_approach => 'encaminhar-para-re-abordagem',
            :re_approach_intention => 'motivo-da-re-abordagem',
            :alignment_meeting_date => 'data-da-reuniao-de-alinhamento',
            :next_aproach_date => 'data-da-proxima-abordagem',
            :goto_alignment_meeting => 'prosseguir-para-alinhamento',
            :new_approach_responsable => 'responsavel-pelo-novo-contato',
            :interruption_approach_intention => 'motivo-da-interrupcao-da-reabordagem',
            :be_host => 'prosseguir-com-host',
            :blacklist => 'alocar-na-blacklist',
            :blacklist_intention => 'motivo-para-a-blacklist',
            :hosting => 'hospedando-no-momento',
            :nps => 'avaliacao'
		}
		super(app_id, fields)
	end

    def find_ors_to_local_lead
        create_models Podio::Item.find_by_filter_values(@app_id, {@fields_name_map[:sync_with_local][:id] => 1}, :sort_by => 'created_on').all
    end

    def find_all
        create_models Podio::Item.find_all(@app_id, :sort_by => 'created_on').all
    end

	def find_with_date_in(field)
        create_models Podio::Item.find_by_filter_values(@app_id, {@fields_name_map[field][:id] => {'from'=>'1900-01-01 00:00:00'}}, :sort_by => 'created_on').all
    end

	def go_to_approach?(host)
		true unless host.first_contact_date.nil? || host.first_contact_responsable.nil? || host.communication_channel.nil?
	end

	def go_to_reapproach?(host)
		true unless host.re_approach != 2 || host.re_approach_intention.nil?
	end

    def go_to_alignment?(host)
        true unless host.re_approach != 1 || host.alignment_meeting_date.nil?
    end

    def return_to_reapproach?(host) #TODO conferir se os campos estão OK no Podio
        true unless host.re_approach != 2 || host.re_approach_intention.nil?
    end

    def finally_go_to_alignment?(host) #TODO confetir se os campos estão OK no Podio
        true unless host.goto_alignment_meeting != 2 || host.next_aproach_date.nil? || host.new_approach_responsable.nil?
    end

	def go_to_whitelist?(host) #TODO número de intercambistas que irá hospedar e resultado da reunião
        true unless host.be_host != 2
	end

	def go_to_blacklist?(host)
		true unless host.be_host != 1 || host.blacklist != 2 || host.blacklist_intention.nil?
	end
end