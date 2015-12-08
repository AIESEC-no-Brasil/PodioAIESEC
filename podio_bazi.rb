require 'active_support'
require 'oauth2'
require 'json'
require 'podio'

require_relative 'control/control_database'
require_relative 'areas/tm/tm'
require_relative 'areas/ogip/ogip'
require_relative 'areas/ogcdp/ogcdp'
require_relative 'areas/igcdp/host'
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
      :app2_5 => 'TM 2.5 Re-abordagem',
      :app2 => 'TM 2. Abordados',
      :app3 => 'TM 3. Seleções',
      :app4 => 'TM 4. Induções',
      :app5 => 'TM 5. CRM',
      :cards => 'TM Cards Layout'
  }

  $enum_oGIP_apps_name = {
      :leads => 'oGIP 1. Inscritos',
      :contacteds => 'oGIP 2. Abordados',
      :epi => 'oGIP 3. EPI',
      :open => 'oGIP 4. Open',
      :ip => 'oGIP 5. In Progress',
      :ma => 'oGIP 6. Match',
      :re => 'oGIP 7. Realize',
      :co => 'oGIP 8. Completed',
      :cards => 'oGIP Cards Layout',
      :january => 'oGIP Janeiro',
      :february => 'oGIP Fevereiro',
      :march => 'oGIP Marco',
      :april => 'oGIP Abril',
      :may => 'oGIP Maio',
      :june => 'oGIP Junho',
      :july => 'oGIP Julho',
      :august => 'oGIP Agosto',
      :september => 'oGIP Setembro',
      :october => 'oGIP Outubro',
      :november => 'oGIP Novembro',
      :december => 'oGIP Dezembro'
  }

  $enum_oGCDP_apps_name = {
      :leads => 'oGCDP 1. Inscritos',
      :contacteds => 'oGCDP 2. Abordados',
      :epi => 'oGCDP 3. EPI',
      :open => 'oGCDP 4. Open',
      :ip => 'oGCDP 5. In Progress',
      :ma => 'oGCDP 6. Match',
      :re => 'oGCDP 7. Realize',
      :co => 'oGCDP 8. Completed',
      :cards => 'oGCDP Cards Layout',
      :january => 'oGCDP Janeiro',
      :february => 'oGCDP Fevereiro',
      :march => 'oGCDP Marco',
      :april => 'oGCDP Abril',
      :may => 'oGCDP Maio',
      :june => 'oGCDP Junho',
      :july => 'oGCDP Julho',
      :august => 'oGCDP Agosto',
      :september => 'oGCDP Setembro',
      :october => 'oGCDP Outubro',
      :november => 'oGCDP Novembro',
      :december => 'oGCDP Dezembro'
  }

  $enum_iGCDP_apps_name = {
      :leads => 'iGCDP 1. Inscritos Host',
      :approach => 'iGCDP 2. Abordagem Host',
      :reapproach => 'iGCDP 1.5. Re-abordagem Host',
      :alignment => 'iGCDP 3. Alinhamento Host',
      :blacklist => 'iGCDP Blacklist Host',
      :whitelist => 'iGCDP 4. Whitelist Host',
      :open => 'iGCDP 1. Open',
      :project => 'iGCDP 2. Projetos',
      :history => 'iGCDP 3. Histórico de Projetos'
  }

  $enum_iGIP_apps_name = {
      :open => 'iGIP 1. Open',
      :match => 'iGIP 2. Match',
      :realize => 'iGIP 3. Realize',
      :history => 'iGIP 4. Histórico de Projetos',
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
                 :bd => 306775405}

  def initialize(test = true, loop = false)
    data = File.read('senha').each_line()
    username = data.next.gsub("\n",'')
    password = data.next.gsub("\n",'')
    api_key = data.next.gsub("\n",'')
    api_secret = data.next.gsub("\n",'')

    @enum_robot = {:username => username, :password => password, :api_key => api_key, :api_secret => api_secret}

    begin
      authenticate
      podioDatabase = ControlDatabase.new(test)
      sleep(3600) unless $podio_flag == true
      $podio_flag = true

      TM.new(podioDatabase.workspaces, podioDatabase.apps)
      OGX_GIP.new(podioDatabase.workspaces, podioDatabase.apps)
      OGX_GCDP.new(podioDatabase.workspaces, podioDatabase.apps)
      HOST.new(podioDatabase.workspaces, podioDatabase.apps)
      Opportunity.new(podioDatabase.workspaces, podioDatabase.apps)
      GIPOpportunity.new(podioDatabase.workspaces, podioDatabase.apps)
      #TODO fin
      #TODO mkt
      #TODO bd
    end while loop
  end

  # Authenticate at Podio with script credentials
  def authenticate
    sleep(3600) unless $podio_flag == true
    $podio_flag = true
    Podio.setup(:api_key => @enum_robot[:api_key], :api_secret => @enum_robot[:api_secret])
    Podio.client.authenticate_with_credentials(@enum_robot[:username], @enum_robot[:password])
  end

end

PodioBAZI.new(false, true)


