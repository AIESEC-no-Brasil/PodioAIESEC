require_relative '../../utils/youth_leader_dao'

# Generic App at ogip workspaces
# @author Luan Corumba <luan.corumba@aiesec.net>
class GlobalTalentDAO < YouthLeaderDAO

	def initialize(app_id)
		fields = {
			:interest => 'programa-de-intersesse',
			:specific_opportunity => 'esta-se-candidatando-a-algum-projetovaga-especifica',
			:cv => 'cv',
			:priority => 'prioridade',
			:first_approach_date => 'data-do-primeiro-contato',
			:first_contact_responsable => 'responsavel-pelo-primeiro-contato',
			:epi_date => 'data-da-epi',
			:epi_responsable => 'responsavel-pela-epi',
			:ep_manager => 'ep-manager',
			:link_to_expa => 'link-do-perfil-no-expa',
			:applying => 'comecou-a-se-aplicar',
			:ops_date => 'data-da-ops',
			:was_in_ops => 'compareceu-a-ops',
			:match_date => 'data-do-match',
			:realize_date => 'data-do-realize', #TODO considerar início e fim
			:erase => 'apagar',
		}
		super(app_id, fields)
	end

	def can_be_local?(i)
		true
	end

	def can_be_contacted?(i)
		true unless self.first_contact_date(i).nil? or self.first_contact_responsable(i).nil?
	end

	def can_be_EPI?(i)
		true unless self.epi_date(i).nil? or self.epi_responsable(i).nil?
	end

	def can_be_open?(i)
		true unless self.link_to_expa(i).nil? or self.ep_manager(i).nil?
	end

	def can_be_ip?(i)
		self.applying?(i)
	end

	def can_be_ma?(i)
		true unless self.match_date(i).nil?
	end

	def can_be_re?(i)
		true unless self.ops_date(i).nil? or self.realize_date(i).nil?
  end
end