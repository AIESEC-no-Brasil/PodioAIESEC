require_relative '../control/podio_app_control'

# Generic App at to work with people
# @author Luan Corumba <luan.corumba@aiesec.net>
class YouthLeaderDAO < PodioAppControl

    def initialize(app_id, extra_fields)
        basic_fields = {
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
            :study_stage => 'formacao',
            :course => 'texto',
            :semester => 'semestre-2',
            :university => 'nome-da-universidadefaculdade',
            :english_level => 'nivel-de-ingles',
            :spanish_level => 'nivel-de-espanhol',
            :best_moment => 'melhor-turno-para-a-aiesec-entrar-em-contato',
            :local_aiesec => 'aiesec-mais-proxima',
            :marketing_channel => 'como-conheceu-a-aiesec',
            :indication => 'nome-da-pessoaentidade-que-lhe-indicou',
            :erase => 'apagar',
            :sync_with_local => 'transferido-para-area-local',
            :cards => 'cards'
        }
        basic_fields = extra_fields.merge(basic_fields) unless extra_fields.nil?
        super(app_id, basic_fields)
    end

    def find_ors_to_local_lead
        create_models Podio::Item.find_by_filter_values(@app_id, {@fields_name_map[:sync_with_local][:id] => 1}, :sort_by => 'created_on').all
    end

    def find_all
        create_models Podio::Item.find_all(@app_id, :sort_by => 'created_on').all
    end
end