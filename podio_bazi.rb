require 'rubygems'
require 'active_support'
require 'oauth2'
require 'json'
require 'podio'

require_relative 'control/control_database'
require_relative 'tm/tm'

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

  def authenticate
    Podio.setup(:api_key => @enum_robot[:api_key], :api_secret => @enum_robot[:api_secret])
    Podio.client.authenticate_with_credentials(@enum_robot[:username], @enum_robot[:password])
  end

end

PodioBAZI.new