require 'uri'

require_relative 'control_database_workspace'
require_relative 'control_database_app'

# Class that initialize and configurate every workspace and application that will be used by the script
# @author Marcus Vinicius de Carvalo <marcus.carvalho@aiesec.net>
class ControlDatabase

  def initialize
    general_im_space_id = 3722237

    sleep(3600) unless $podio_flag == true
    $podio_flag = true

    response = Podio.connection.get do |req|
      req.url("/app/space/#{general_im_space_id}/", false)
    end
    main_apps = Podio::Application.list(response.body)
    if (response.env[:response_headers]["x-rate-limit-remaining"].to_i <= 10) then
      $podio_flag = false
    end

    for app in main_apps do
      case app['config']['name']
        when 'workspaces'
          workspace_control = app
        when 'app'
          app_control = app
        when 'log'
          log_control = app
      end
    end

    @workspace_control_items = ControlDatabaseWorkspace.new(workspace_control['app_id'])
    @app_control_items = ControlDatabaseApp.new(app_control['app_id'])
    @log_control_items = ControlDatabaseApp.new(log_control['app_id'])
  end

  # Get class that control all items at 'workspaces' app
  def workspaces
    @workspace_control_items
  end

  # Get class that control all items at 'app' app
  def apps
    @app_control_items
  end

  # Get class that control all items at 'log' app
  def logs
    @log_control_items
  end
end