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
# == Priority of functional areas to work:
# * 1. tm
# * 2. ogip
# * 3. ogcdp
# * 4. mkt
# * 5. fin
# * 6. igip
# * 7. igcdp
# * 8. bd (Alumnus)
class PodioBAZI
  def initialize
    data = File.read('senha').each_line()
    username = data.next.gsub("\n",'')
    password = data.next.gsub("\n",'')
    api_key = data.next.gsub("\n",'')
    api_secret = data.next.gsub("\n",'')

    @enum_robot = {:username => username, :password => password, :api_key => api_key, :api_secret => api_secret}

    test = true

    authenticate
    podioDatabase = ControlDatabase.new(test)
    TM.new(podioDatabase.workspaces, podioDatabase.apps)
    OGX_GIP.new(podioDatabase.workspaces, podioDatabase.apps)
    #OGX_GCDP.new(podioDatabase.workspaces, podioDatabase.apps)
    #TODO GCDPi
    #TODO GIPi
    #TODO mkt
    #TODO fin
    #TODO bd/PR
  end

  # Authenticate at Podio with robozinho credentials
  def authenticate
    Podio.setup(:api_key => @enum_robot[:api_key], :api_secret => @enum_robot[:api_secret])
    Podio.client.authenticate_with_credentials(@enum_robot[:username], @enum_robot[:password])
  end

end

loop = true
while(loop)
  PodioBAZI.new
  loop = false
end

