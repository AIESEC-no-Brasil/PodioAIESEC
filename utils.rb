class Class
  # @private
  # Acessor to generate Text Podio Fields Getter and Setter
  # @param relationship_id [Integer] Item id of the relationship you wnat to retrieve
  def text_attr_accessor(*args)
    args.each do |arg|
      #Here's the getter
      self.class_eval("
        # Getter for #{arg} of the Global Talent
        # @param index [Integer] Index of the item you want to retrieve the value
        # @return [String] #{arg} of the Global Talent
        def #{arg}(index)
          i = get_field_index_by_external_id(index, @fields[:#{arg}])
          fields(index, i).to_s unless i.nil?
        end
      ")
      #Here's the setter
      self.class_eval("
        # Setter for #{arg} of the Global Talent
        # @param val [String] The value you want to set
        # @return [String] #{arg} of the Global Talent
        def #{arg}=(val)
          @#{arg}=val.to_s
        end
      ")
    end
  end

  # @private
  # Acessor to generate Text Podio Fields Getter and Setter
  # @param relationship_id [Integer] Item id of the relationship you wnat to retrieve
  def number_attr_accessor(*args)
    args.each do |arg|
      #Here's the getter
      self.class_eval("
        # Getter for #{arg} of the Global Talent
        # @param index [Integer] Index of the item you want to retrieve the value
        # @return [Integer] #{arg} of the Global Talent
        def #{arg}(index)
          i = get_field_index_by_external_id(index, @fields[:#{arg}])
          fields(index, i).to_i unless i.nil?
        end
      ")
      #Here's the setter
      self.class_eval("
        # Setter for #{arg} of the Global Talent
        # @param val [Integer] The value you want to set
        # @return [Integer] #{arg} of the Global Talent
        def #{arg}=(val)
          @#{arg} = val.to_i unless val.nil?
        end
      ")
    end
  end

  # @private
  # Acessor to generate Date Podio Fields Getter and Setter
  # @param relationship_id [Integer] Item id of the relationship you wnat to retrieve
  def date_attr_accessor(*args)
    args.each do |arg|
      #Here's the getter
      self.class_eval("
        # Getter for #{arg} of the Global Talent
        # @param index [Integer] Index of the item you want to retrieve the value
        # @return [DateTime] #{arg} of the Global Talent
        def #{arg}(index)
          i = get_field_index_by_external_id(index, @fields[:#{arg}])
          date = values(index, i)[0]['start'] unless i.nil?
          DateTime.strptime(date,'%Y-%m-%d %H:%M:%S') unless date.nil?
        end
      ")
      #Here's the setter
      self.class_eval("
        # Setter for #{arg} of the Global Talent
        # @param val [DateTime] The value you want to set
        # @return [String] #{arg} of the Global Talent
        def #{arg}=(val)
          @#{arg} = val.strftime('%Y-%m-%d %H:%M:%S') unless val.nil?
        end
      ")
      #Here's the setter with datas
      /self.class_eval("
        # Setter for #{arg} date format of the Global Talent
        # @param year [Integer] 
        # @param month [Integer] 
        # @param day [Integer] 
        # @param hour [Integer] 
        # @param minute [Integer] 
        def #{arg}=(year,month,day,hour,minute,second)
          @#{arg} = DateTime.new(year,month,day,hour,minute,second).strftime('%Y-%m-%d %H:%M:%S')
        end
      ")/
    end
  end

  # @private
  # Acessor to generate Doble Date Podio Fields Getter and Setter
  # @param relationship_id [Integer] Item id of the relationship you wnat to retrieve
  def dates_attr_accessor(*args)
    args.each do |arg|
      #Here's the getter
      self.class_eval("
        # Getter for #{arg} of the Global Talent
        # @param index [Integer] Index of the item you want to retrieve the value
        # @return [Array] Array of state and end date of #{arg} of the Global Talent
        def #{arg}(index)
          @#{arg}
        end
      ")
      #Here's the setter
      self.class_eval("
        # Setter for #{arg} of the Global Talent
        # @param val [Array] The values you want to set
        # @return [Array] #{arg} of the Global Talent
        def #{arg}=(val)
          @#{arg}=val
        end
      ")
    end
  end

  # @private
  # Acessor to generate boolean category Podio Fields Getter and Setter
  # @param Array of Symbol with the field name
  def boolean_attr_accessor(*args)
    args.each do |arg|
      #Here's the getter for the boolean
      self.class_eval("
        # Getter for #{arg} of the Global Talent
        # @param index [Integer] Index of the item you want to retrieve the value
        # @return [Boolean] If the Global Talent is #{arg}
        def #{arg}?(index)
          #{arg}(index) == $enum_boolean.key($enum_boolean[:sim])
        end
      ")
      #Here's the getter for the category value
      self.class_eval("
        # Getter for #{arg} of the Global Talent
        # @param index [Integer] Index of the item you want to retrieve the value
        # @return [Symbol] #{arg} category index of the Global Talent
        def #{arg}(index)
          i = get_field_index_by_external_id(index, @fields[:#{arg}])
          $enum_boolean.key(fields(index, i)['id'].to_i) unless i.nil?
        end
      ")
      #Here's the setter
      self.class_eval("
        # Setter for #{arg} of the Global Talent
        # @param val [Symbol] The value you want to set
        # @return [Integer] #{arg} of the Global Talent
        def #{arg}=(val)
          @#{arg} = $enum_boolean[val]
        end
      ")
    end
  end

  # @private
  # Acessor to generate category Podio Fields Getter and Setter
  # @param Array of Symbol with the field name
  def category_attr_accessor(*args)
    args.each do |arg|
      #Here's the getter
      self.class_eval("
        # Getter for #{arg} of the Global Talent
        # @param index [Integer] Index of the item you want to retrieve the value
        # @return [Symbol] #{arg} category index of the Global Talent
        def #{arg}(index)
          i = get_field_index_by_external_id(index, @fields[:#{arg}])
          $enum_#{arg}.key(fields(index, i)['id'].to_i) unless i.nil?
        end
      ")
      #Here's the setter
      self.class_eval("
        # Setter for #{arg} of the Global Talent
        # @param val [Symbol] The value you want to set
        # @return [Integer] #{arg} of the Global Talent
        def #{arg}=(val)
          @#{arg}= $enum_#{arg}[val]
        end
      ")
    end
  end

  # @private
  # Acessor to generate multiple category Podio Fields Getter and Setter
  # @param Array of Symbol with the field name
  def list_attr_accessor(*args)
    args.each do |arg|
      #Here's the getter
      self.class_eval("
        # Getter for #{arg} of the Global Talent
        # @param index [Integer] Index of the item you want to retrieve the value
        # @return [Hash] #{arg} of the Global Talent
        def #{arg}(index)
          @#{arg};
        end
      ")
      #Here's the setter
      self.class_eval("
        # Setter for #{arg} of the Global Talent
        # @param val [Hash] The value you want to set
        # @return [Hash] #{arg} of the Global Talent
        def #{arg}=(val)
          @#{arg}=val
        end
      ")
    end
  end

  # @private
  # Acessor to generate Phone and Emails Podio Fields Getter and Setter
  # @param Array of Symbol with the field name
  def multiple_attr_accessor(*args)
    args.each do |arg|
      #Here's the getter
      self.class_eval("
        # Getter for #{arg} of the Global Talent
        # @param index [Integer] Index of the item you want to retrieve the value
        # @return [Hash] #{arg} of the Global Talent
        def #{arg}(index)
          i = get_field_index_by_external_id(index, @fields[:#{arg}])
          values(index, i) unless i.nil?
        end
      ")
      #Here's the setter
      self.class_eval("
        # Setter for #{arg} of the Global Talent
        # @param val [Hash] The value you want to set
        # @return [Hash] #{arg} of the Global Talent
        def #{arg}=(val);
          @#{arg}=val;
        end
      ")
    end
  end

  # @private
  # Acessor to generate Reference Podio Fields Getter and Setter
  # @param Array of Symbol with the field name
  def reference_attr_accessor(*args)
    args.each do |arg|
      #Here's the getter
      self.class_eval("
        # Getter for #{arg} of the Global Talent
        # @param index [Integer] Index of the item you want to retrieve the value
        # @return [Integer] Id of #{arg} reference of the Global Talent
        def #{arg}_id(index)
          i = get_field_index_by_external_id(index, @fields[:#{arg}])
          fields(index, i)['item_id'].to_i unless i.nil?
        end
      ")
      #Here's the setter
      self.class_eval("
        # Setter for #{arg} of the Global Talent
        # @param val [Integer] The reference id you want to set
        # @return [Integer] #{arg} of the Global Talent
        def #{arg}_id=(val)
          @#{arg}_id = val.to_i unless val.nil?
        end
      ")
    end
  end

  # @private
  # Acessor to generate Link Podio Fields Getter and Setter
  # @param Array of Symbol with the field name
  def link_attr_accessor(*args)
    args.each do |arg|
      #Here's the getter
      self.class_eval("
        # Getter for #{arg} of the Global Talent
        # @param index [Integer] Index of the item you want to retrieve the value
        # @return [Hash] #{arg} of the Global Talent
        def #{arg}(index)
          i = get_field_index_by_external_id(index, @fields[:#{arg}])
          field = values(index, i) unless i.nil?
          field[0]['embed'] unless field.nil?
        end
      ")
      #Here's the setter
      self.class_eval("
        # Setter for #{arg} of the Global Talent
        # @param val [Hash] The value you want to set
        # @return [Hash] #{arg} of the Global Talent
        def #{arg}=(val)
          @#{arg}_id = val
        end
      ")
    end
  end
end