require 'active_support'
require 'oauth2'
require 'json'
require 'podio'

require_relative 'control/control_database'
require_relative 'areas/tm/tm'
require_relative 'areas/ogip/ogip'
require_relative 'areas/ogcdp/ogcdp'
require_relative 'areas/host/host'
require_relative 'areas/igcdp/opportunity'
require_relative 'areas/igip/gip_opportunity'

# This is the root class of the PodioBAZI project. The PodioBAZI project creates standards procedures for different
# areas of AIESEC in Brazil's Podio. It also automate procedures by controled data manipulation/duplication.
#
# @author Marcus Vinicius de Carvalho (marcus.carvalho@aiesec.net)

# = This class initialize and start the batch script
class PodioBAZI
  $podio_flag = true

  $enum_TM_apps_name = {
      :app1 => 'TM 1. Inscritos',
      :app2 => 'TM 2. Abordados',
      :app2_5 => 'TM 2.5. Re-abordagem',
      :app3 => 'TM 3. Seleções',
      :app4 => 'TM 4. Induções',
      :app5 => 'TM 5. CRM'
  }

  $enum_oGIP_apps_name = {
      :leads => 'oGIP 1. Inscritos',
      :contacteds => 'oGIP 2. Abordados',
      :epi => 'oGIP 3. EPI',
      :open => 'oGIP 4. Open',
      :ip => 'oGIP 5. In Progress',
      :ma => 'oGIP 6. Match',
      :re => 'oGIP 7. Realize',
      :co => 'oGIP 8. Completed'
  }

  $enum_oGCDP_apps_name = {
      :leads => 'oGCDP 1. Inscritos',
      :contacteds => 'oGCDP 2. Abordados',
      :epi => 'oGCDP 3. EPI',
      :open => 'oGCDP 4. Open',
      :ip => 'oGCDP 5. In Progress',
      :ma => 'oGCDP 6. Match',
      :re => 'oGCDP 7. Realize',
      :co => 'oGCDP 8. Completed'
  }

  $enum_HOST_apps_name = {
      :leads => 'Host 1. Inscritos',
      :approach => 'Host 2. Abordagem',
      :reapproach => 'Host 2.5. Re-abordagem',
      :alignment => 'Host 3. Alinhamento',
      :blacklist => 'Host Blacklist',
      :whitelist => 'Host 4. Whitelist'
  }

  $enum_iGCDP_apps_name = {
      :open => 'iGCDP 1. Open',
      :project => 'iGCDP 2. Projetos',
      :history => 'iGCDP 3. Histórico de Projetos'
  }

  $enum_iGIP_apps_name = {
      :open => 'iGIP 1. Open',
      :in_progress => 'iGIP 2. In-Progress',
      :match => 'iGIP 3. Match',
      :realize => 'iGIP 4. Realize',
      :history => 'iGIP 5. Histórico de Projetos',
  }

  $enum_type = { :ors => 1,
                 :national => 2,
                 :local => 3 }
  $enum_area = { :tm => 306775522,
                 :ogip => 306774653,
                 :ogcdp => 306774783,
                 :mkt => 306775660,
                 :fin => 306775701,
                 :igip => 306774699,
                 :igcdp => 306774749,
                 :bd => 306775405,
                 :host => 361615672}

  def initialize
    data = File.read('senha').each_line()
    username = data.next.gsub("\n",'')
    password = data.next.gsub("\n",'')
    api_key = data.next.gsub("\n",'')
    api_secret = data.next.gsub("\n",'')

    @enum_robot = {:username => username, :password => password, :api_key => api_key, :api_secret => api_secret}

    authenticate
    podioDatabase = ControlDatabase.new

    TM.new(podioDatabase)
    OGX_GCDP.new(podioDatabase)
    OGX_GIP.new(podioDatabase)
    HOST.new(podioDatabase)
    #Opportunity.new(podioDatabase.workspaces, podioDatabase.apps)
    #GIPOpportunity.new(podioDatabase.workspaces, podioDatabase.apps)

    #TODO fin
    #TODO mkt
    #TODO bd
  end

  # Authenticate at Podio with script credentials
  def authenticate
    sleep(3600) unless $podio_flag == true
    $podio_flag = true
    Podio.setup(:api_key => @enum_robot[:api_key], :api_secret => @enum_robot[:api_secret])
    Podio.client.authenticate_with_credentials(@enum_robot[:username], @enum_robot[:password])
  end

end

PodioBAZI.new


