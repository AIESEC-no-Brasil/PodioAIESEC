require_relative 'podio_app_control'

# Class that control every item at 'workspaces' app at 'IM General' app
# @author Marcus Vinicius de Carvalho <marcus.carvalho@aiesec.net>
class ControlDatabaseWorkspace < PodioAppControl
  def initialize(app_id)
    @fields = {:name => 'title',
               :id => 'id-2',
               :entity => 'entity',
               :area => 'area-2',
               :type => 'type',
               :robot => 'robottype',
               :year => 'year'}
    super(app_id,@fields)
  end

  # Get name of the workspace
  # @param index [Integer] Index of the item you want to retrieve
  # @return [String] The name of the workspace
  def name(index)
    i = get_field_index_by_external_id(index,@fields[:name])
    fields(index, i).to_s unless i.nil?
  end

  # Get Podio id of the workspace
  # @param index [Integer] Index of the item you want to retrieve
  # @return [Integer] The Podio id of the workspace
  def id(index)
    i = get_field_index_by_external_id(index,@fields[:id])
    fields(index, i).to_i unless i.nil?
  end

  # Get the item_id of the workspace's entity
  # @param index [Integer] Index of the item you want to retrieve
  # @return [Integer] The item_id of the app's entity
  def entity(index)
    i = get_field_index_by_external_id(index,@fields[:entity])
    fields(index, i)['item_id'].to_i unless i.nil?
  end

  # Get the item_id of the workspace's area
  # @param index [Integer] Index of the item you want to retrieve
  # @return [Integer] The item_id of the workspace's area
  def area(index)
    i = get_field_index_by_external_id(index,@fields[:area])
    fields(index, i)['item_id'].to_i unless i.nil?
  end

  # Get the category id of the workspace's type (ors, national, local)
  # @param index [Integer] Index of the item you want to retrieve
  # @return [Integer] Category id of the workspace's type
  # * ors = 1
  # * national = 2
  # * local = 3
  def type(index)
    i = get_field_index_by_external_id(index,@fields[:type])
    fields(index, i)['id'].to_i unless i.nil?
  end

  # Get the user role that the script has on that workspace (admin, regular, light)
  # @param index [Integer] Index of the item you want to retrieve
  # @return [Integer] Category id of the user role
  # * admin = 1
  # * regular = 2
  # * light = 3
  def robot_type(index)
    i = get_field_index_by_external_id(index,@fields[:robot])
    fields(index,i)['id'].to_i unless i.nil?
  end

  # Get the workspace's active year
  # @param index[Integer] Index of the item you want to retrieve
  # @return [Integer] Year
  def year(index)
    i = get_field_index_by_external_id(index,@fields[:year])
    fields(index, i).to_i unless i.nil?
  end
end