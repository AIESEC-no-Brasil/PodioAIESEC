require_relative '../control/podio_app_control'

# Generic App at to work with people
# @author Luan Corumba <luan.corumba@aiesec.net>
class YouthLeaderDAO < PodioAppControl

    def initialize(app_id, extra_fields)
        basic_fields = {
            :name_tm_host => 'titulo',
            :name_ogcp_ogip => 'nome',
            :sex => 'sexo',
            :birthdate => 'data-de-nascimento',
            :birthdate_ogcdp_ogip => 'data-de-nascimento-2',
            :phones => 'telefone',
            :phones_ogcdp_ogip => 'telefone-2',
            :emails => 'email',
            :address_host => 'endereco-completo',
            :zip_code => 'cep',
            :city => 'cidade',
            :state => 'estado',
            :type_of_host => 'receberem-em',
            :number_of_trainees_to_host => 'quantos-intercambistas-pretende-receber',
            :maximum_host_time => 'tempo-maximo-que-pretende-ser-host',
            :state_ogcdp_ogip => 'estado2',
            :study_stage => 'formacao',
            :study_stage_ogcdp_ogip => 'formacao2',
            :university => 'universidade',
            :university_ogcdp_ogip => 'universidade-2',
            :course => 'curso',
            :semester => 'semestre-2',
            :semester_ogcdp_ogip => 'semestre-3',
            :graduation_year => 'ano-de-formacao',
            :english_level => 'nivel-de-ingles',
            :spanish_level => 'nivel-de-espanhol',
            :best_moment_tm_host => 'melhor-turno-para-a-aiesec-entrar-em-contato',
            :best_moment_ogcdp_ogip => 'melhor-turno-test',
            :how_to_be_contacted_ogcdp_ogip => 'como-voce-prefere-ser-contactado',
            :interested_thopic_ogip => 'programa-de-interesse',
            :interested_thopic_ogcdp => 'programa-de-interesse2',
            :local_aiesec => 'aiesec-mais-proxima',
            :local_aiesec_ogcdp_ogip => 'aiesec-mais-proxima2',
            :marketing_channel_host => 'categoria',
            :marketing_channel => 'como-conheceu-a-aiesec',
            :marketing_channel_ogcdp_ogip => 'como-voce-conheceu-a-aiesec',
            :indication => 'nome-da-pessoaentidade-que-lhe-indicou',
            :sync_with_local => 'transferido-para-area-local',
            :id_local => 'id-local',
            :id_local_1 => 'id-local-1',
            :id_local_2 => 'id-local-2',
            :id_local_gcdp_1 => 'id-local-gcdp-1',
            :id_local_gcdp_2 => 'id-local-gcdp-2',
            :id_local_gip_1 => 'id-local-gip-1',
            :id_local_gip_2 => 'id-local-gip-2',
            :lead_date => 'data-da-inscricao'
        }
        basic_fields.merge!(extra_fields) unless extra_fields.nil?
        super(app_id, basic_fields)
    end

    def find_ors_to_local_lead
        attributes = {:sort_by => 'last_edit_on', :created_by => {:type => 'user', :id => 0}}
        attributes[:filters] = {@fields_name_map[:sync_with_local][:id] => 1}
        attributes[:limit] = 500

        response = Podio.connection.post do |req|
            req.url "/item/app/#{@app_id}/filter/"
            req.body = attributes
        end
        check_rate_limit_remaining(response)
        create_models Podio::Item.collection(response.body).all
    end

    def find_national_local_id(local_id)
      attributes = {:sort_by => 'last_edit_on'}
      attributes[:filters] = {@fields_name_map[:id_local][:id] => {'from'=>local_id,'to'=>local_id}}

      response = Podio.connection.post do |req|
        req.url "/item/app/#{@app_id}/filter/"
        req.body = attributes
      end
      check_rate_limit_remaining(response)
      create_models Podio::Item.collection(response.body).all
    end

    def find_national_local_id_1(local_id)
      attributes = {:sort_by => 'last_edit_on'}
      attributes[:filters] = {@fields_name_map[:id_local_1][:id] => {'from'=>local_id,'to'=>local_id}}

      response = Podio.connection.post do |req|
        req.url "/item/app/#{@app_id}/filter/"
        req.body = attributes
      end
      check_rate_limit_remaining(response)
      create_models Podio::Item.collection(response.body).all
    end

    def find_national_local_id_2(local_id)
      attributes = {:sort_by => 'last_edit_on'}
      attributes[:filters] = {@fields_name_map[:id_local_2][:id] => {'from'=>local_id,'to'=>local_id}}

      response = Podio.connection.post do |req|
        req.url "/item/app/#{@app_id}/filter/"
        req.body = attributes
      end
      check_rate_limit_remaining(response)
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
      attributes = {:sort_by => 'last_edit_on', :created_by => {:type => 'user', :id => 0}}
      attributes[:limit] = 500

      response = Podio.connection.post do |req|
        req.url "/item/app/#{@app_id}/filter/"
        req.body = attributes
      end
      check_rate_limit_remaining(response)
      create_models Podio::Item.collection(response.body).all
    end

    def check_rate_limit_remaining(response)
      if (response.env[:response_headers]["x-rate-limit-remaining"].to_i <= 15) then
        $podio_flag = false
      end
    end
end