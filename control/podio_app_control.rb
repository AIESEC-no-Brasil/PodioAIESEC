# Class that control every item app.
# Must be inherited by another class.
# @author Marcus Vinicius de Carvalho <marcus.carvalho@aiesec.net>
class PodioAppControl

  $type_of_data = {
    :category => 'category',
    :app      => 'app',
    :number   => 'number',
    :text     => 'text',
    :contact  => 'contact'
  }

  # @param app_id [Integer] Id of the app
  def initialize(app_id, fields)
    @app_id = app_id
    @fields = fields
    @max = 500 # Maximum number of elements per podio request
    @item = nil
  end

  # Get item at index
  # @param index [Integer] Index of the item you want to retrieve
  # @return [array]
  def at_index(index)
    prepare_item(index) if @item.nil?
    @item[0][index%@max]
  end

  # Get item_id of item at index
  # @param index [Integer] Index of the item you want to retrieve
  # @return [Integer] Item_id of the item at index
  def item_id(index)
    at_index(index)[:item_id].to_i
  end

  # Total number of items at app
  # @return [Integer] Total number of items at app
  def total_count
    prepare_item(0) if @item.nil?
    @item[-1].to_i
  end

  # Number of items at podio request for the app
  # @return [Integer] Number of items at podio request for the app
  def count
    prepare_item(0) if @item.nil?
    @item[-2].to_i
  end

  # Refresh the list of items from the database
  def refresh_item_list
    @index = nil
    prepare_item(0)
  end

  private

  # @private
  # Count number of filled fields at index
  # @param index [Integer] Index of the item you want to retrieve
  # @return [Integer] Number of filled fields at index
  def count_fields(index)
    at_index(index)[:fields].size
  end

  # @private
  # Field index of a field using its external_id as reference
  # @param index [Integer] Index of the item you want to retrieve
  # @param external_id [String] External_id of that field you are searching for
  # @return [Integer] field index of the external_id you are searching for
  def get_field_index_by_external_id(index,external_id)
    prepare_item(index)
    limit = count_fields(index)

    for i in 0..limit
      break if i >= limit
      break if at_index(index)[:fields][i]['external_id'].eql? external_id
    end

    if i < limit then i else nil end
  end

  # @private
  # Label of a field using its external_id as reference
  # @param index [Integer] Index of the item you want to retrieve
  # @param external_id [String] External_id of that field you are searching for
  # @return [String] label of the external_id you are searching for
  def get_label_by_external_id(index,external_id)
    i = get_field_index_by_external_id(index,external_id)
    at_index(index)[:fields][i]['label'].to_s unless i.nil?
  end

  # @private
  # Type of data of a field using its external_id as reference
  # @param index [Integer] Index of the item you want to retrieve
  # @param external_id [String] External_id of that field you are searching for
  # @return [String] Type of data of the external_id you are searching for
  def get_type_by_external_id(index,external_id)
    i = get_field_index_by_external_id(index,external_id)
    at_index(index)[:fields][i]['type'].to_s unless i.nil?
  end

  # @private
  # Make calls though Podio API to retrieve a list of items from the app
  # @param index [Integer] Index of the item you want to retrieve
  # @return [nil]
  def prepare_item(index)
    @item = Podio::Item.find_all(@app_id, :offset => (index/@max)*@max, :limit => @max, :sort_by => 'created_on') if @index.nil? || @index != (index/@max)*@max
    @index = (index/@max)*@max
    nil
  end

  # @private
  # Shortcut on the Podio item json array to get to it field value
  # @param index [Integer] Index of the item you want to retrieve
  # @param label_position [Integer] Index of the label you want to retrieve
  def fields(index, label_position)
    at_index(index)[:fields][label_position]['values'][0]['value']
  end

  # @private
  # Shortcut on the Podio item json array to get to it field values. Used just for Phone and Email fields.
  # @param index [Integer] Index of the item you want to retrieve
  # @param label_position [Integer] Index of the label you want to retrieve
  # @return [Array] Array of hashs with field values
  def values(index, label_position)
    at_index(index)[:fields][label_position]['values']
  end

  # @private
  # Get the value from a field at a relationship field
  # @param relationship_id [Integer] Item id of the relationship you wnat to retrieve
  # @param external_id [String] External_id of the field you want to retrieve
  # @return [Integer] if field is category (category id)
  # @return [Integer] if field is app (referency) (referency item id)
  # @return [Integer] if field is number (number)
  # @return [Integer] if field is a contact/profile (contact id)
  # @return [String]  if field is text (text)
  def get_field_from_relationship(relationship_id, external_id)
    relationship = Podio::Item.find(relationship_id)
    limit = relationship[:fields].size

    for i in 0..limit
      break if i >= limit
      break if relationship[:fields][i]['external_id'].eql? external_id
    end

    result = relationship[:fields][i]['values'][0]['value'] if i < limit
    type = relationship[:fields][i]['type'] if i < limit

    case type
      when $type_of_data[:category] then if i < limit then result['id'].to_i         else nil end
      when $type_of_data[:app]      then if i < limit then result['item_id'].to_i    else nil end
      when $type_of_data[:number]   then if i < limit then result.to_i               else nil end
      when $type_of_data[:contact]  then if i < limit then result['profile_id'].to_i else nil end
      when $type_of_data[:text]     then if i < limit then result.to_s               else nil end
      else nil
    end
  end
end