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
        basic_fields.merge!(extra_fields) unless extra_fields.nil?
        super(app_id, basic_fields)
    end

    def find_ors_to_local_lead
        attributes = {:sort_by => 'created_on'}
        attributes[:filters] = {@fields_name_map[:sync_with_local][:id] => 1}

        response = Podio.connection.post do |req|
            req.url "/item/app/#{@app_id}/filter/"
            req.body = attributes
        end
        if (response.env[:response_headers]["x-rate-limit-remaining"].to_i <= 10) then
          $podio_flag = false
        end
        create_models Podio::Item.collection(response.body).all
    end

    def find_by_filter_values(app_id, filter_values, attributes={})
      attributes[:filters] = filter_values
      collection Podio.connection.post { |req|
        req.url "/item/app/#{app_id}/filter/"
        req.body = attributes
      }.body
    end

    def find_all
      response = Podio.connection.get do |req|
        req.url("/item/app/#{@app_id}/", {:sort_by => 'created_on'})
      end
      if (response.env[:response_headers]["x-rate-limit-remaining"].to_i <= 10) then
        $podio_flag = false
      end
      create_models Podio::Item.collection(response.body).all
    end
end