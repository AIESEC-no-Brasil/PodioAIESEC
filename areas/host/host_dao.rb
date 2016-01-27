require_relative '../../control/podio_app_control'

# Generic App at ogip workspaces
# @author Luan Corumba <luan.corumba@aiesec.net>
class HostDAO < YouthLeaderDAO

  def initialize(app_id)
    fields = {
      :first_contact_date => 'data-do-primeiro-contato',
      :first_contact_responsable => 'responsavel-pelo-primeiro-contato',
      :communication_channel => 'canal-de-comunicacao-utilizado',
      :re_approach => 'encaminhar-para-re-abordagem',
      :re_approach_intention => 'motivo-da-re-abordagem',
      :alignment_meeting_date => 'data-da-reuniao-de-alinhamento',
      :next_aproach_date => 'data-da-proxima-abordagem',
      :goto_alignment_meeting => 'prosseguir-para-alinhamento',
      :new_approach_responsable => 'responsavel-pelo-novo-contato',
      :interruption_approach_intention => 'motivo-da-interrupcao-da-reabordagem',
      :result_alignment => 'resultado-da-reuniao-de-alinhamento',
      :numbers_of_trainee_to_host => 'numero-de-trainees-que-ira-hospedar',
      :be_host => 'prosseguir-com-host',
      :blacklist => 'alocar-na-blacklist',
      :blacklist_intention => 'motivo-para-a-blacklist',
      :hosting => 'hospedando-no-momento',
      :nps => 'avaliacao',
      :trainees => 'trainees-alocados'
    }
    super(app_id, fields)
  end

  def go_to_approach?(host)
    begin
      true unless host.first_contact_date.nil? ||
          host.first_contact_responsable.nil? ||
          host.communication_channel.nil?
    rescue => exception
      puts 'ERROR'
      puts exception.backtrace
      puts 'ERROR'
    end
  end

  def go_to_reapproach?(host)
    begin
      true unless !say_yes?(host.re_approach) ||
          host.re_approach_intention.nil?
    rescue => exception
      puts 'ERROR'
      puts exception.backtrace
      puts 'ERROR'
    end
  end

  def go_to_alignment?(host)
    begin
      true unless say_yes?(host.re_approach) ||
          host.alignment_meeting_date.nil?
    rescue => exception
      puts 'ERROR'
      puts exception.backtrace
      puts 'ERROR'
    end
  end

  def finally_go_to_alignment?(host)
    begin
      true unless !say_yes?(host.goto_alignment_meeting) ||
          host.next_aproach_date.nil? ||
          host.new_approach_responsable.nil?
    rescue => exception
      puts 'ERROR'
      puts exception.backtrace
      puts 'ERROR'
    end
  end

  def go_to_whitelist?(host)
    begin
      true unless !say_yes?(host.be_host)
    rescue => exception
      puts 'ERROR'
      puts exception.backtrace
      puts 'ERROR'
    end
  end

  def go_to_blacklist?(host)
    begin
      true unless say_yes?(host.be_host) ||
          !say_yes?(host.blacklist) ||
          host.blacklist_intention.nil?
    rescue => exception
      puts 'ERROR'
      puts exception.backtrace
      puts 'ERROR'
    end
  end
end