require_relative 'podio_app_control'

class ControlDatabaseApp < PodioAppControl
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

  def name(index)
    i = get_external_id_index(index,@fields[:name])
    fields(index, i).to_s unless i.nil?
  end

  def id(index)
    i = get_external_id_index(index,@fields[:id])
    fields(index, i).to_i unless i.nil?
  end

  def workspace_id(index)
    i = get_external_id_index(index,@fields[:workspace])
    fields(index, i)['item_id'].to_i unless i.nil?
  end

  def entity(index)
    get_field_from_relationship(workspace_id(index), @fields_extra[:entity], $type_of_data[:referency])
  end

  def area(index)
    get_field_from_relationship(workspace_id(index), @fields_extra[:area], $type_of_data[:referency])
  end

  def type(index)
    get_field_from_relationship(workspace_id(index), @fields_extra[:type], $type_of_data[:category])
  end

  def year(index)
    get_field_from_relationship(workspace_id(index), @fields_extra[:year], $type_of_data[:integer])
  end
end