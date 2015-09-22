require 'active_support'
require 'oauth2'
require 'json'
require 'podio'

require_relative 'control/control_database'
require_relative 'areas/tm/tm'
require_relative 'areas/ogip/ogip'
require_relative 'areas/ogcdp/ogcdp'

# This is the root class of the PodioBAZI project. The PodioBAZI project creates standards procedures for different
# areas of AIESEC in Brazil's Podio. It also automate procedures by controled data manipulation/duplication.
#
# @author Marcus Vinicius de Carvalho (marcus.carvalho@aiesec.net)

# = This class initialize and start the batch script
class PodioBAZI
  $enum_TM_apps_name = {
      :app1 => '1. Inscritos',
      :app1_5 => '1.5 Re-abordagem',
      :app2 => '2. Abordados',
      :app3 => '3. Seleções',
      :app4 => '4. Induções',
      :app5 => '5. CRM',
      :cards => 'Cards Layout'
  }

  $enum_oGIP_apps_name = {
      :leads => '1. Inscritos',
      :contacteds => '2. Abordados',
      :epi => '3. EPI',
      :open => '4. Open',
      :ip => '5. In Progress',
      :ma => '6. Match',
      :re => '7. Realize',
      :co => '8. Completed',
      :cards => 'Cards Layout'
  }

  $enum_oGCDP_apps_name = {
      :leads => '1. Inscritos',
      :contacteds => '2. Abordados',
      :epi => '3. EPI',
      :open => '4. Open',
      :ip => '5. In Progress',
      :ma => '6. Match',
      :re => '7. Realize',
      :co => '8. Completed'
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

      TM.new(podioDatabase.workspaces, podioDatabase.apps)
      #OGX_GIP.new(podioDatabase.workspaces, podioDatabase.apps)
      #OGX_GCDP.new(podioDatabase.workspaces, podioDatabase.apps)
      #TODO GCDPi
      #TODO GIPi
      #TODO mkt
      #TODO fin
      #TODO bd
    end while loop
  end

  # Authenticate at Podio with script credentials
  def authenticate
    Podio.setup(:api_key => @enum_robot[:api_key], :api_secret => @enum_robot[:api_secret])
    Podio.client.authenticate_with_credentials(@enum_robot[:username], @enum_robot[:password])
  end

end

PodioBAZI.new(true, true)


