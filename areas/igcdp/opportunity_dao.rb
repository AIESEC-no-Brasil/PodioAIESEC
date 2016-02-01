require_relative '../../utils/youth_leader_dao'

# Generic App at ogip workspaces
# @author Luan Corumba <luan.corumba@aiesec.net>
class OpportunityDAO < YouthLeaderDAO

  def initialize(app_id)
    fields = {
        :expa_id => 'id-no-expa',
        :expa_link => 'link-do-expa',
        :organization => 'organizacao',
        :opens => 'numero-de-opens',
        :situation => 'situacao',
        :open_date => 'data-do-open',
        :project => 'projeto',
        :local_entity => 'local-entity',
        :local_reference => 'local-reference-id',
        :trainees => 'trainees',
        :tnt_checklist => 'visita-de-fechamento-feita',
        :status => 'status',
        :percentage_occupied_vacancies => 'de-vagas-ocupadas',
        :average_ma_time => 'tempo-medio-de-ma',
        :number_trainees_ma => 'de-trainees-ma',
        :number_trainees_re => 'de-trainees-re'
    }
    super(app_id, fields)
  end

  def upgrade(opportunity)
    opportunity
  end

  def new_model(model_hash)
    url = model_hash[:expa_link]['url']
    model_hash[:expa_link] = Podio::Embed.create( url )
    super(model_hash)
  end

  def get_id(opportunity)
    test_expa_link(opportunity) | text_op_link(opportunity)
  end

  def test_expa_link(opportunity)
    opportunity.expa_link['url'].sub('https://experience.aiesec.org/#/opportunities/','').to_i |
        opportunity.expa_link['url'].sub('http://experience.aiesec.org/#/opportunities/','').to_i |
        opportunity.expa_link['url'].sub('experience.aiesec.org/#/opportunities/','').to_i |
        opportunity.expa_link['url'].sub('www.experience.aiesec.org/#/opportunities/','').to_i |
        opportunity.expa_link['url'].sub('https://experience-v1.aiesec.org/#/opportunities/','').to_i |
        opportunity.expa_link['url'].sub('http://experience-v1.aiesec.org/#/opportunities/','').to_i |
        opportunity.expa_link['url'].sub('experience-v1.aiesec.org/#/opportunities/','').to_i |
        opportunity.expa_link['url'].sub('www.experience-v1.aiesec.org/#/opportunities/','').to_i
  end

  def text_op_link(opportunity)
    opportunity.expa_link['url'].sub('https://internships.aiesec.org/#/volunteering/','').to_i |
        opportunity.expa_link['url'].sub('http://internships.aiesec.org/#/volunteering/','').to_i |
        opportunity.expa_link['url'].sub('internships.aiesec.org/#/volunteering/','').to_i |
        opportunity.expa_link['url'].sub('www.internships.aiesec.org/#/volunteering/','').to_i |
        opportunity.expa_link['url'].sub('https://internships-v1.aiesec.org/#/volunteering/','').to_i |
        opportunity.expa_link['url'].sub('http://internships-v1.aiesec.org/#/volunteering/','').to_i |
        opportunity.expa_link['url'].sub('internships-v1.aiesec.org/#/volunteering/','').to_i |
        opportunity.expa_link['url'].sub('www.internships-v1.aiesec.org/#/volunteering/','').to_i
  end

  def new_open?(opportunity)
    attributes = nil
    expa = test_expa_link(opportunity)
    op = text_op_link(opportunity)
    if expa != 0
      attributes[:filters] = {@fields_name_map[:expa_id][:id] => {'to'=>expa,'from'=>expa}}
    elsif op != 0
      attributes[:filters] = {@fields_name_map[:expa_id][:id] => {'to'=>op,'from'=>op}}
    end
    if expa || op != 0
      attributes = {:sort_by => 'last_edit_on'}
      attributes[:limit] = 1

      response = Podio.connection.post do |req|
        req.url "/item/app/#{@app_id}/filter/"
        req.body = attributes
      end
      check_rate_limit_remaining(response)
      Podio::Item.collection(response.body).all.length == 0
    elsif
      nil
    end
  end

  def find_newbies
    attributes[:filters] = {@fields_name_map[:situation][:id] => 1}
    attributes = {:sort_by => 'last_edit_on'}
    attributes[:limit] = 500

    response = Podio.connection.post do |req|
      req.url "/item/app/#{@app_id}/filter/"
      req.body = attributes
    end
    check_rate_limit_remaining(response)
    create_models Podio::Item.collection(response.body).all
  end

  def find_approveds
    create_models Podio::Item.find_by_filter_values(@app_id, {@fields_name_map[:situation][:id] => 4}, :sort_by => 'created_on').all
  end

  def find_closeds
    create_models Podio::Item.find_by_filter_values(@app_id, {@fields_name_map[:tnt_checklist][:id] => 2}, :sort_by => 'created_on').all
  end

  def find_with_date_in(field)
    create_models Podio::Item.find_by_filter_values(@app_id, {@fields_name_map[field][:id] => {'from'=>'1900-01-01 00:00:00'}}, :sort_by => 'created_on').all
  end

  def local_open_updated?(national_opportunity,local_opportunity)
    national_opportunity.opens != local_opportunity.opens
  end

  def update_local_opens(national_opportunity,local_opportunity)
    if national_opportunity.opens > local_opportunity.opens
      national_opportunity.opens
    else
      local_opportunity.opens
    end
  end

  def local_project_updated?(national_opportunity,local_opportunity)
    ok = true
    local_opportunity.to_h.each do |key, value|
      if national_opportunity[key] != value
        ok = false
      end
    end
    ok
  end

  def update_local_project(national_opportunity,local_opportunity)
    local_opportunity.to_h.each_key do |key|
      local_opportunity[key] = national_opportunity[key]
    end
  end

end