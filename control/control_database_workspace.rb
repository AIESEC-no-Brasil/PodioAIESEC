require_relative 'podio_app_control'

class ControlDatabaseWorkspace < PodioAppControl
  def initialize(app_id)
    super(app_id)
    @fields = {:name => 'title',
               :id => 'id-2',
               :entity => 'entity',
               :area => 'area-2',
               :type => 'type',
               :robot => 'robottype',
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

  def entity(index)
    i = get_external_id_index(index,@fields[:entity])
    fields(index, i)['item_id'].to_i unless i.nil?
  end

  def area(index)
    i = get_external_id_index(index,@fields[:area])
    fields(index, i)['item_id'].to_i unless i.nil?
  end

  def type(index)
    i = get_external_id_index(index,@fields[:type])
    fields(index, i)['id'].to_i unless i.nil?
  end

  def robot_type(index)
    i = get_external_id_index(index,@fields[:robot])
    fields(index,i)['id'].to_i unless i.nil?
  end

  def year(index)
    i = get_external_id_index(index,@fields[:year])
    fields(index, i).to_i unless i.nil?
  end
end