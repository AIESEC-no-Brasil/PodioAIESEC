require 'active_support'
require 'oauth2'
require 'json'
require 'podio'
require 'minitest/autorun'
require 'mocha/mini_test'

require_relative '../enums'
require_relative '../utils'
require_relative '../oGIP/global_talent'
require_relative '../control/youth_leader'

class OGX_GIP_Test < Minitest::Test

	test_text_field :ors, :name, :city, :course, :university, :indication
	test_big_text_field :ors, :address
	test_number_field :ors, :zip_code
	test_date_field :ors, :birthdate
	test_boolean_field :ors, :erase, :sync_with_local, :specific_opportunity
	test_category_field :ors, :sex, :study_stage, :semester, :english_level, :spanish_level, :best_moment, :marketing_channel, :carrier, :interest
	test_phones_field :ors, :phones
	test_emails_field :ors, :emails
	test_reference_field :ors, 306772401, :state_id
	test_reference_field :ors, 306817550, :local_aiesec_id
	#test_link_field :ors,24

	def setup
		data = File.read('senha').each_line()
		username = data.next.gsub("\n",'')
		password = data.next.gsub("\n",'')
		api_key = data.next.gsub("\n",'')
		api_secret = data.next.gsub("\n",'')

		@enum_robot = {:username => username, :password => password, :api_key => api_key, :api_secret => api_secret}

		test = true

		Podio.setup(:api_key => @enum_robot[:api_key], :api_secret => @enum_robot[:api_secret])
		Podio.client.authenticate_with_credentials(@enum_robot[:username], @enum_robot[:password])

		@ors = GlobalTalent.new(13299717)
		@lead = GlobalTalent.new(13300013)
		@contacted = GlobalTalent.new(13308833)
		@epi = GlobalTalent.new(13308848)
		@open = GlobalTalent.new(13308849)
		@in_progress = GlobalTalent.new(13308857)
		@ma= GlobalTalent.new(13308860)
		@re = GlobalTalent.new(13308864)
	end

	def test_bagunça
		/assert_equal(@ors.nil?,false)
		assert_equal(@lead.nil?,false)
		assert_equal(@contacted.nil?,false)
		assert_equal(@epi.nil?,false)
		assert_equal(@open.nil?,false)
		assert_equal(@in_progress.nil?,false)
		assert_equal(@ma.nil?,false)
		assert_equal(@re.nil?,false)/
	end

	def test_create_in_ors
		#@ors.refresh_item_list
		values = {
			:name => 'Luan Corumba',
			:sex => $enum_sex[:masculino],
			:birthdate => DateTime.strptime('1990-09-29 00:00:00','%Y-%m-%d %H:%M:%S'),
			:phones => [{"type" => "work", "value" => "7996042544"}, {"type" => "mobile", "value" => "799199000"}],
			:carrier => $enum_carrier[:tim],
			:emails => [{"type" => "work", "value" => "luan@corumba.net"}],
			:address => 'Rua Paulo Silva',
			:zip_code => 49032500,
			:city => 'Aracaju',
			:state_id => 306772401,
			:study_stage => $enum_study_stage[:superior_incompleto],
			:course => 'Ciência da Computação',
			:semester =>  $enum_semester[:s2],
			:university => 'Universidade Federal de Sergipe',
			:english_level => $enum_english_level[:basico],
			:spanish_level => $enum_spanish_level[:intermediario],
			:best_moment => $enum_best_moment[:manha],
			:local_aiesec_id => 306817550,
			:marketing_channel => $enum_marketing_channel[:friends],
			:indication => 'Thieres Rafael',
			:erase => $enum_boolean[:nao],
			:interest => $enum_interest[:startups],
			:specific_opportunity => $enum_boolean[:nao],
			:priority => $enum_priority[:p1],
			:first_contact_date => DateTime.strptime('2015-09-02 00:00:00','%Y-%m-%d %H:%M:%S'),
			:first_contact_responsable_id => 2986280,
			:epi_date => DateTime.strptime('2015-09-02 00:00:00','%Y-%m-%d %H:%M:%S'),
			:epi_responsable_id => 2986280,
			:ep_manager_id => 2986280,
			:link_to_expa => 'http://google.com',
			:applying => $enum_boolean[:sim],
			:ops_date => DateTime.strptime('2015-09-02 00:00:00','%Y-%m-%d %H:%M:%S'),
			:was_in_ops => $enum_boolean[:sim],
			:match_date => DateTime.strptime('2015-09-02 00:00:00','%Y-%m-%d %H:%M:%S'),
			:realize_date => DateTime.strptime('2015-09-02 00:00:00','%Y-%m-%d %H:%M:%S')
		}
		/@ors.name = values[:name]
		@ors.sex = values[:sex]
		@ors.birthdate = values[:birthdate]
		@ors.phones = values[:phones]
		@ors.carrier = values[:carrier]
		@ors.emails = values[:emails]
		@ors.address = values[:address]
		@ors.zip_code = values[:zip_code]
		@ors.city = values[:city]
		@ors.state_id = values[:state_id]
		@ors.study_stage = values[:study_stage]
		@ors.course = values[:course]
		@ors.semester = values[:semester]
		@ors.university = values[:university]
		@ors.english_level = values[:english_level]
		@ors.spanish_level = values[:spanish_level]
		@ors.best_moment = values[:best_moment]
		@ors.local_aiesec_id = values[:local_aiesec_id]	
		@ors.marketing_channel = values[:marketing_channel]
		@ors.indication = values[:indication]
		@ors.erase = values[:erase]
		@ors.interest = values[:interest]
		@ors.specific_opportunity = values[:specific_opportunity]
		@ors.priority = values[:priority]
		@ors.first_contact_date = values[:first_contact_date]
		@ors.first_contact_responsable_id = values[:first_contact_responsable_id]
		@ors.epi_date = values[:epi_date]
		@ors.epi_responsable_id = values[:epi_responsable_id]
		@ors.ep_manager_id = values[:ep_manager_id]
		@ors.link_to_expa = values[:link_to_expa]
		@ors.applying = values[:applying]
		@ors.ops_date = values[:ops_date]
		@ors.was_in_ops = values[:was_in_ops]
		@ors.match_date = values[:match_date]
		@ors.realize_date = values[:realize_date]
		global_talent = @ors.create
		assert_equal(global_talent.nil?,false)

		index = nil
		limit = @ors.total_count - 1
		(0..limit).each do |i|
			if global_talent[:item_id].to_i == @ors.item_id(i)
				index = i
				break
			end
		end

		#item = Podio::Item.find(global_talent[:item_id].to_i)
		#assert_equal(@item.nil?, false)
		assert_equal(@ors.name(index), values[:name])
		assert_equal(@ors.sex(index), $enum_sex.key(values[:sex]))
		assert_equal(@ors.birthdate(index), values[:birthdate])
/
	end
 end