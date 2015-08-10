require_relative 'podio_app_control'

# Class that control every item at 'app' app at 'IM General' app
# @author Marcus Vinicius de Carvalho <marcus.carvalho@aiesec.net>
class ControlDatabaseApp < PodioAppControl
  # @param app_id [Integer] Id of the 'app' app
  def initialize(app_id)
    super(app_id)
    @fields = {:name => 'title',
               :id => 'id-2',
               :workspace => 'relationship'}

    @fields_extra = {:entity => 'entity',
                     :area => 'area-2',
                     :type => 'type',
                     :year => 'year'}
  end

  # Get name of the app
  # @param index [Integer] Index of the item you want to retrieve
  # @return [String] The name of the app
  def name(index)
    i = get_external_id_index(index,@fields[:name])
    fields(index, i).to_s unless i.nil?
  end

  # Get Podio id of the app
  # @param index [Integer] Index of the item you want to retrieve
  # @return [Integer] The Podio id of the app
  def id(index)
    i = get_external_id_index(index,@fields[:id])
    fields(index, i).to_i unless i.nil?
  end

  # Get podio id of the app's workspace
  # @param index [Integer] Index of the item you want to retrieve
  # @return [Integer] The podio if of the app's workspace
  def workspace_id(index)
    i = get_external_id_index(index,@fields[:workspace])
    fields(index, i)['item_id'].to_i unless i.nil?
  end

  # Get the item_id of the app's entity
  # @param index [Integer] Index of the item you want to retrieve
  # @return [Integer] The item_id of the app's entity
  def entity(index)
    get_field_from_relationship(workspace_id(index), @fields_extra[:entity], $type_of_data[:referency])
  end

  # Get the item_id of the apps's area
  # @param index [Integer] Index of the item you want to retrieve
  # @return [Integer] The item_id of the app's area
  def area(index)
    get_field_from_relationship(workspace_id(index), @fields_extra[:area], $type_of_data[:referency])
  end

  # Get the category id of the app's type (ors, national, local)
  # @param index [Integer] Index of the item you want to retrieve
  # @return [Integer] Category id of the app's type
  # * ors = 1
  # * national = 2
  # * local = 3
  def type(index)
    get_field_from_relationship(workspace_id(index), @fields_extra[:type], $type_of_data[:category])
  end

  # Get the app's active year
  # @param index[Integer] Index of the item you want to retrieve
  # @return [Integer] Year
  def year(index)
    get_field_from_relationship(workspace_id(index), @fields_extra[:year], $type_of_data[:integer])
  end
end