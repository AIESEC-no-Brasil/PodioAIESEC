require_relative '../../utils/youth_leader_dao'

# Generic App at ogip workspaces
# @author Luan Corumba <luan.corumba@aiesec.net>
class InternDAO < YouthLeaderDAO

	def initialize(app_id)
		fields = {
			
		}
		super(app_id, fields)
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