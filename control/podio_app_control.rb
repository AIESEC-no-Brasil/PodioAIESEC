class PodioAppControl
  $type_of_data = {:category  => 1,
                   :referency => 2,
                   :integer   => 3,
                   :profile   => 4}

  def initialize(app_id)
    @app_id = app_id
  end

  def at_index(index)
    prepare_item(index) if @item.nil?
    @item
  end

  def item_id(index)
    at_index(index)[0][0][:item_id]
  end

  def total_count
    at_index(0)[2]
  end

  def count
    at_index(0)[1]
  end

  protected

  def count_fields(index)
    at_index(index)[0][0][:fields].size
  end

  def get_external_id_index(index,external_id)
    prepare_item(index)
    limit = count_fields(index)

    for i in 0..limit
      break if i >= limit
      break if at_index(0)[0][0][:fields][i]['external_id'].eql? external_id
    end

    if i < limit then i else nil end
  end

  def prepare_item(index)
    @item = Podio::Item.find_all(@app_id, :offset => index, :limit => 1, :sort_by => 'created_on') if @index.nil? || @index != index
    @index = index
  end

  def fields(index, label_position)
    at_index(index)[0][0][:fields][label_position]['values'][0]['value']
  end

  def get_field_from_relationship(relationship_id, external_id, type_of_data)
    relationship = Podio::Item.find(relationship_id)
    limit = relationship[:fields].size

    for i in 0..limit
      break if i >= limit
      break if relationship[:fields][i]['external_id'].eql? external_id
    end

    result = relationship[:fields][i]['values'][0]['value'] if i < limit

    case type_of_data
      when $type_of_data[:category] then if i < limit then result['id'].to_i else nil end
      when $type_of_data[:referency] then if i < limit then result['item_id'].to_i else nil end
      when $type_of_data[:integer] then if i < limit then result.to_i else nil end
      when $type_of_data[:profile] then if i < limit then result['profile_id'].to_i else nil end
      else nil
    end
  end
end