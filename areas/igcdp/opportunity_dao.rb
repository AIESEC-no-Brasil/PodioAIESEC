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
			:tnt_checklist => 'visita-de-fechamento-feita'
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
		expa_ssl = opportunity.expa_link['url'].sub('https://experience.aiesec.org/#/opportunities/','').to_i
		expa = opportunity.expa_link['url'].sub('experience.aiesec.org/#/opportunities/','').to_i
		op_ssl = opportunity.expa_link['url'].sub('https://internships.aiesec.org/#/volunteering/','').to_i
		op = opportunity.expa_link['url'].sub('internships.aiesec.org/#/volunteering/','').to_i
		expa | expa_ssl | op | op_ssl
	end

	def new_open?(opportunity)
		expa = opportunity.expa_link['url'].sub('https://experience.aiesec.org/#/opportunities/','').to_i |
				opportunity.expa_link['url'].sub('http://experience.aiesec.org/#/opportunities/','').to_i 
		op = opportunity.expa_link['url'].sub('https://internships.aiesec.org/#/volunteering/','').to_i |
				opportunity.expa_link['url'].sub('http://internships.aiesec.org/#/volunteering/','').to_i
		if expa != 0
			Podio::Item.find_by_filter_values(@app_id, {@fields_name_map[:expa_id][:id] => {'to'=>expa,'from'=>expa}}).all.length == 0
		elsif op != 0
			Podio::Item.find_by_filter_values(@app_id, {@fields_name_map[:expa_id][:id] => {'to'=>op,'from'=>op}}).all.length == 0
		end
	end

	def find_newbies
        create_models Podio::Item.find_by_filter_values(@app_id, {@fields_name_map[:situation][:id] => 1}, :sort_by => 'created_on').all
	end

	def find_approveds
        create_models Podio::Item.find_by_filter_values(@app_id, {@fields_name_map[:situation][:id] => 2}, :sort_by => 'created_on').all
	end

	def find_closeds
        create_models Podio::Item.find_by_filter_values(@app_id, {@fields_name_map[:tnt_checklist][:id] => 2}, :sort_by => 'created_on').all
	end

	def find_with_date_in(field)
        create_models Podio::Item.find_by_filter_values(@app_id, {@fields_name_map[field][:id] => {'from'=>'1900-01-01 00:00:00'}}, :sort_by => 'created_on').all
    end

	def can_be_contacted?(global_talent)
		true unless global_talent.first_approach_date.nil? or global_talent.first_contact_responsable.nil?
	end

	def can_be_EPI?(global_talent)
		true unless global_talent.epi_date.nil? or global_talent.epi_responsable.nil?
	end

	def can_be_open?(global_talent)
		true unless global_talent.link_to_expa.nil? or global_talent.ep_manager.nil?
	end

	def can_be_ip?(global_talent)
		global_talent.applying == 2
	end

	def can_be_ma?(global_talent)
		true unless global_talent.match_date.nil?
	end

	def can_be_re?(global_talent)
		true unless global_talent.ops_date.nil? or global_talent.realize_date.nil?
	end
end