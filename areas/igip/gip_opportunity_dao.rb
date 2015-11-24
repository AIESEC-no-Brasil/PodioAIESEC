require_relative '../../utils/youth_leader_dao'
require 'date'

# Generic App at ogip workspaces
# @author Luan Corumba <luan.corumba@aiesec.net>
class GIPOpportunityDAO < YouthLeaderDAO

	def initialize(app_id)
		fields = {
			:expa_id => 'id-no-expa',
			:expa_link => 'link-do-expa',
			:organization => 'organizacao',
			:opens => 'numero-de-opens',
			:situation => 'situacao',
			:open_date => 'data-do-open',
			:realize_date => 'data-do-realize',
			:project => 'projeto',
			:trainees => 'trainees',
			:tracking => 'acompanhamento',
			:local_entity => 'local-entity',
			:local_reference => 'local-reference-id',
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
		expa = opportunity.expa_link['url'].sub('http://experience.aiesec.org/#/opportunities/','').to_i
		op_ssl = opportunity.expa_link['url'].sub('https://opportunities.aiesec.org/opportunity/','').to_i
		op = opportunity.expa_link['url'].sub('http://opportunities.aiesec.org/opportunity/','').to_i
		expa | expa_ssl | op | op_ssl
	end

	def new_open?(opportunity)
		expa = opportunity.expa_link['url'].sub('https://experience.aiesec.org/#/opportunities/','').to_i |
				opportunity.expa_link['url'].sub('http://experience.aiesec.org/#/opportunities/','').to_i 
		op = opportunity.expa_link['url'].sub('https://opportunities.aiesec.org/opportunity/','').to_i |
				opportunity.expa_link['url'].sub('http://opportunities.aiesec.org/opportunity/','').to_i
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
        create_models Podio::Item.find_by_filter_values(@app_id, {@fields_name_map[:situation][:id] => 4}, :sort_by => 'created_on').all
	end

	def find_with_date_in(field)
        create_models Podio::Item.find_by_filter_values(@app_id, {@fields_name_map[field][:id] => {'from'=>'1900-01-01 00:00:00'}}, :sort_by => 'created_on').all
    end

	def can_be_realize?(opportunity)
		true unless opportunity.trainees.nil? or opportunity.realize_date.nil? or
				(!opportunity.realize_date.nil? and
					(DateTime.strptime(opportunity.realize_date['start'], '%Y-%m-%d %H:%M:%S') > DateTime.now))
	end

	def can_be_history?(opportunity)
		true unless opportunity.tracking.index(2).nil?
	end

	def sync_open(local,national)
		if national.opens > local.opens
			local.opens = national.opens
			local.update
		end
		national.update if not reverse_sync_opportunities(local,national,[])
	end

	def sync_match(local,national)
		if sync_opportunities(local,national,[:trainees,:realize_date]) == false
			local.update
		end

		att = false
		local.trainees = [] << local.trainees if local.trainees.class == Fixnum
		national.trainees = [] << national.trainees if national.trainees.class == Fixnum

		#Unless the fields isn't equal (sync), sync and update
		unless local.trainees.length == national.trainees.length && (national.trainees & local.trainees == national.trainees)
			national.trainees = local.trainees
			att = true
		end
		unless local.realize_date == national.realize_date
			national.realize_date = local.realize_date
			att = true
		end
		national.update if att
	end

	def sync_realize(local,national)
		if sync_opportunities(local,national,[:tracking]) == false
			local.update
		end

		local.tracking = [] << local.tracking if local.tracking.class == Fixnum
		national.tracking = [] << national.tracking if national.tracking.class == Fixnum

		#Unless the fields isn't equal (sync), let's find what need to be updated
		unless local.tracking.length == national.tracking.length && (national.tracking & local.tracking == national.tracking)
			
			local_new = local.tracking - national.tracking #User set new categories
			local_deleted = national.tracking - local.tracking #User unset some categories

			if not local_new.empty?
				national.tracking = national.tracking + local_new
				national.update
			end
			if not local_deleted.empty?
				local.tracking = local.tracking + local_deleted
				local.update
			end
		end
	end

	private

	def sync_opportunities(local,national,ignoreds)
		ok = true
		local.to_h.each do |key, value|
			if national[key] != value && ignoreds.include?(key)
				local[key] = national[key]
				ok = false
			end
		end
		ok
	end

	def reverse_sync_opportunities(local,national,ignoreds)
		ok = true
		local.to_h.each do |key, value|
			if national[key] != value && ignoreds.include?(key)
				national[key] = local[key]
				ok = false
			end
		end
		ok
	end
end