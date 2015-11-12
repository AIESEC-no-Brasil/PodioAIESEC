require_relative '../../control/podio_app_control'

class Cards < PodioAppControl

  def initialize(app_id)
    fields = {
        :name => 'title',
        :email => 'email-2',
        :responsible => 'responsavel-local',
        :modification_date => 'data-da-modificacao',
        :stage => 'fase',
        :number_of_days_at_this_stage => 'numero-de-dias-nesse-estagio'
    }
    super(app_id, fields)
  end

end