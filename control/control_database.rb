require 'uri'

require_relative 'control_database_workspace'
require_relative 'control_database_app'

class ControlDatabase
  attr_accessor :workspace_control_items
  attr_accessor :app_control_items
  attr_accessor :log_control_items

  def initialize(test = false)
    workspace_control = nil
    app_control = nil
    log_control = nil
    @workspace_control_items = nil
    @app_control_items = nil
    @log_control_items = nil

    if test
      general_im_space_id = 3709357
    else
      general_im_space_id = 3722237
    end

    main_apps = Podio::Application.find_all_for_space(general_im_space_id,false)

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

  end

  def workspaces
    @workspace_control_items
  end

  def apps
    @app_control_items
  end
end