require_relative 'podio_app_control'

# Class that control every item at 'app' app at 'IM General' app
# @author Marcus Vinicius de Carvalho <marcus.carvalho@aiesec.net>
class ControlDatabaseApp < PodioAppControl
  # @param app_id [Integer] Id of the 'app' app
  def initialize(app_id)
    @fields = {:name => 'title',
               :id => 'id-2',
               :workspace => 'relationship',
               :workspace_id => 'workspace-id',
               :workspace_id_2 => 'workspace-id-2',
               :workspace_id_3 => 'workspace-id-3',
               :workspace_id_4 => 'workspace-id-4'}

    @fields_extra = {:entity => 'entity',
                     :area => 'area-2',
                     :type => 'type',
                     :year => 'year'}
    super(app_id,@fields)
  end

  # Get name of the app
  # @param index [Integer] Index of the item you want to retrieve
  # @return [String] The name of the app
  def name(index)
    i = get_field_index_by_external_id(index,@fields[:name])
    fields(index, i).to_s unless i.nil?
  end

  # Get Podio id of the app
  # @param index [Integer] Index of the item you want to retrieve
  # @return [Integer] The Podio id of the app
  def id(index)
    i = get_field_index_by_external_id(index,@fields[:id])
    fields(index, i).to_i unless i.nil?
  end

  # Get Podio id of the app's workspace
  # @param index [Integer] Index of the item you want to retrieve
  # @return [Integer] The podio if of the app's workspace
  def workspace_id(index)
    i = get_field_index_by_external_id(index,@fields[:workspace])
    fields(index, i)['item_id'].to_i unless i.nil?
  end

  def workspace_id_calculated(index)
    i = get_field_index_by_external_id(index,@fields[:workspace_id])
    fields(index, i).to_i unless i.nil?
  end

  def workspace_id2_calculated(index)
    i = get_field_index_by_external_id(index,@fields[:workspace_id_2])
    fields(index, i).to_i unless i.nil?
  end

  def workspace_id3_calculated(index)
    i = get_field_index_by_external_id(index,@fields[:workspace_id_3])
    fields(index, i).to_i unless i.nil?
  end

  def workspace_id4_calculated(index)
    i = get_field_index_by_external_id(index,@fields[:workspace_id_4])
    fields(index, i).to_i unless i.nil?
  end

  # Get the item_id of the app's entity
  # @param index [Integer] Index of the item you want to retrieve
  # @return [Integer] The item_id of the app's entity
  def entity(index)
    get_field_from_relationship(workspace_id(index), @fields_extra[:entity])
  end

  # Get the item_id of the apps's area
  # @param index [Integer] Index of the item you want to retrieve
  # @return [Integer] The item_id of the app's area
  def area(index)
    get_field_from_relationship(workspace_id(index), @fields_extra[:area])
  end

  # Get the category id of the app's type (ors, national, local)
  # @param index [Integer] Index of the item you want to retrieve
  # @return [Integer] Category id of the app's type
  # * ors = 1
  # * national = 2
  # * local = 3
  def type(index)
    get_field_from_relationship(workspace_id(index), @fields_extra[:type])
  end

  # Get the app's active year
  # @param index[Integer] Index of the item you want to retrieve
  # @return [Integer] Year
  def year(index)
    get_field_from_relationship(workspace_id(index), @fields_extra[:year])
  end
end
