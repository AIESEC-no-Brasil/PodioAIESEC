require 'active_support'
require 'oauth2'
require 'json'
require 'podio'

require_relative 'control/control_database'
require_relative 'tm/tm'

# This is the root class of the PodioBAZI project. The PodioBAZI project creates standards procedures for different
# areas of AIESEC in Brazil's Podio. It also automate procedures by controled data manipulation/duplication.
#
# @author Marcus Vinicius de Carvalho (marcus.carvalho@aiesec.net)

# = This class initialize and start the batch script
# == Priority of functional areas to work:
# * 1. TM
# * 2. oGIP
# * 3. oGCDP
# * 4. MKT
# * 5. FIN
# * 6. iGIP
# * 7. iGCDP
# * 8. PR/BD (Alumnus)
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
    #TODO GIPo
    #TODO GCDPo
    #TODO MKT
    #TODO FIN
    #TODO GIPi
    #TODO GCDPi
    #TODO BD/PR
  end

  # Authenticate at Podio with robozinho credentials
  def authenticate
    Podio.setup(:api_key => @enum_robot[:api_key], :api_secret => @enum_robot[:api_secret])
    Podio.client.authenticate_with_credentials(@enum_robot[:username], @enum_robot[:password])
  end

end

PodioBAZI.new
