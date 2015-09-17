require 'test/unit'

class MyTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # Fake test
  def test_fail

    fail('Not implemented')
  end
end

=begin

# @private
# Generate Test Text Podio Fields
# @param App [String] App id
def test_text_field(app,*args)
  args.each do |arg|
    #Here's the getter
    self.class_eval("
        # Tester for #{arg} of the #{app} app
        def test_#{arg}_field_on_#{app}
          text = 'test_#{arg}_field_on_#{app}'
          @#{app}.#{arg} = text
          item = @#{app}.create
          index = nil
          limit = @#{app}.total_count - 1
          (0..limit).each do |i|
            if item[:item_id].to_i == @#{app}.item_id(i)
              index = i
              break
            end
          end
          assert_equal(@#{app}.#{arg}(index), text)
          @#{app}.delete(index)
        end
      ")
  end
end

# @private
# Generate Test Multiline Text Podio Fields
# @param App [String] App id
def test_big_text_field(app,*args)
  args.each do |arg|
    #Here's the getter
    self.class_eval("
        # Tester for #{arg} of the #{app} app
        def test_#{arg}_field_on_#{app}
          text = 'test_#{arg}_field_on_#{app}'
          @#{app}.#{arg} = text
          item = @#{app}.create
          index = nil
          limit = @#{app}.total_count - 1
          (0..limit).each do |i|
            if item[:item_id].to_i == @#{app}.item_id(i)
              index = i
              break
            end
          end
          assert_equal(@#{app}.#{arg}(index), '<p>'text'</p>')
          @#{app}.delete(index)
        end
      ")
  end
end

# @private
# Generate Test Number Podio Fields
# @param App [String] App id
def test_number_field(app,*args)
  args.each do |arg|
    #Here's the getter
    self.class_eval("
        # Tester for #{arg} of the #{app} app
        def test_#{arg}_field_on_#{app}
          number = rand(100000000)
          @#{app}.#{arg} = number
          item = @#{app}.create
          index = nil
          limit = @#{app}.total_count - 1
          (0..limit).each do |i|
            if item[:item_id].to_i == @#{app}.item_id(i)
              index = i
              break
            end
          end
          assert_equal(@#{app}.#{arg}(index), number)
          @#{app}.delete(index)
        end
      ")
  end
end

# @private
# Generate Test Date Podio Fields
# @param App [String] App id
def test_date_field(app,*args)
  args.each do |arg|
    #Here's the getter
    self.class_eval("
        # Tester for #{arg} of the #{app} app
        def test_#{arg}_field_on_#{app}
          date = Date.today-rand(10000)
          date = date.to_datetime
          @#{app}.#{arg} = date
          item = @#{app}.create
          index = nil
          limit = @#{app}.total_count - 1
          (0..limit).each do |i|
            if item[:item_id].to_i == @#{app}.item_id(i)
              index = i
              break
            end
          end
          assert_equal(@#{app}.#{arg}(index), date)
          @#{app}.delete(index)
        end
      ")
  end
end

# @private
# Generate Test DateTime Podio Fields
# @param App [String] App id
def test_datetime_field(app,*args)
  args.each do |arg|
    #Here's the tester
    self.class_eval("
        # Tester for #{arg} of the #{app} app
        def test_#{arg}_field_on_#{app}
          date = DateTime.now
          @#{app}.#{arg} = date
          item = @#{app}.create
          index = nil
          limit = @#{app}.total_count - 1
          (0..limit).each do |i|
            if item[:item_id].to_i == @#{app}.item_id(i)
              index = i
              break
            end
          end
          assert_equal(@#{app}.#{arg}(index), date)
          @#{app}.delete(index)
        end
      ")
  end
end

# @private
# Generate Test Boolean Podio Fields
# @param App [String] App id
def test_boolean_field(app,*args)
  args.each do |arg|
    #Here's the tester to :sim
    self.class_eval("
        # Tester for #{arg} of the #{app} app
        def test_#{arg}_field_on_#{app}
          @#{app}.#{arg} = :sim
          item = @#{app}.create
          index = nil
          limit = @#{app}.total_count - 1
          (0..limit).each do |i|
            if item[:item_id].to_i == @#{app}.item_id(i)
              index = i
              break
            end
          end
          assert_equal(:sim, @#{app}.#{arg}(index))
          @#{app}.delete(index)
        end
      ")

    #Here's the tester to :nao
    self.class_eval("
        # Tester for #{arg} of the #{app} app
        def test_#{arg}_field_on_#{app}
          @#{app}.#{arg} = :nao
          item = @#{app}.create
          index = nil
          limit = @#{app}.total_count - 1
          (0..limit).each do |i|
            if item[:item_id].to_i == @#{app}.item_id(i)
              index = i
              break
            end
          end
          assert_equal(:nao, @#{app}.#{arg}(index))
          @#{app}.delete(index)
        end
      ")
  end
end

# @private
# Generate Test Category Podio Fields
# @param App [String] App id
def test_category_field(app,*args)
  args.each do |arg|
    #Here's the testers
    self.class_eval("
        # Tester for #{arg} of the #{app} app
        def test_#{arg}_field_on_#{app}
          $enum_#{arg}.each_key do |key|
            @#{app}.#{arg} = key
            item = @#{app}.create
            @#{app}.refresh_item_list
            index = nil
            limit = @#{app}.total_count - 1
            (0..limit).each do |i|
              if item[:item_id].to_i == @#{app}.item_id(i)
                index = i
                break
              end
            end
            assert_equal(key, @#{app}.#{arg}(index))
            @#{app}.delete(index)
          end
        end
      ")
  end
end

# @private
# Generate Test Category Podio Fields
# @param App [String] App id
def test_list_category_field(app,*args)
  args.each do |arg|
    #Here's the testers
    self.class_eval("
        # Tester for #{arg} of the #{app} app
        def test_#{arg}_field_on_#{app}
          $enum_#{arg}.each_key do |key|
            @#{app}.#{arg} = key
            item = @#{app}.create
            @#{app}.refresh_item_list
            index = nil
            limit = @#{app}.total_count - 1
            (0..limit).each do |i|
              if item[:item_id].to_i == @#{app}.item_id(i)
                index = i
                break
              end
            end
            assert_equal(key, @#{app}.#{arg}(index))
            @#{app}.delete(index)
          end
        end
      ")
  end
end

# @private
# Generate Test Phones Podio Fields
# @param App [String] App id
def test_phones_field(app,*args)
  args.each do |arg|
    #Here's the testers
    self.class_eval("
        # Tester for #{arg} of the #{app} app
        def test_#{arg}_field_on_#{app}
          phones = [{'type' => 'work', 'value' => '7996042544'}, {'type' => 'mobile', 'value' => '799199000'}]
          @#{app}.#{arg} = phones
          item = @#{app}.create
          index = nil
          limit = @#{app}.total_count - 1
          (0..limit).each do |i|
            if item[:item_id].to_i == @#{app}.item_id(i)
              index = i
              break
            end
          end
          assert_equal(phones, @#{app}.#{arg}(index))
          @#{app}.delete(index)
        end
      ")
  end
end

# @private
# Generate Test Emails Podio Fields
# @param App [String] App id
def test_emails_field(app,*args)
  args.each do |arg|
    #Here's the testers
    self.class_eval("
        # Tester for #{arg} of the #{app} app
        def test_#{arg}_field_on_#{app}
          emails = [{'type' => 'work', 'value' => 'luan@corumba.net'}]
          @#{app}.#{arg} = emails
          item = @#{app}.create
          index = nil
          limit = @#{app}.total_count - 1
          (0..limit).each do |i|
            if item[:item_id].to_i == @#{app}.item_id(i)
              index = i
              break
            end
          end
          assert_equal(emails, @#{app}.#{arg}(index))
          @#{app}.delete(index)
        end
      ")
  end
end

# @private
# Generate Test Reference Podio Fields
# @param App [String] App id
def test_reference_field(app,reference_id,*args)
  args.each do |arg|
    #Here's the testers
    self.class_eval("
        # Tester for #{arg} of the #{app} app
        def test_#{arg}_field_on_#{app}
          @#{app}.#{arg} = #{reference_id}
          item = @#{app}.create
          index = nil
          limit = @#{app}.total_count - 1
          (0..limit).each do |i|
            if item[:item_id].to_i == @#{app}.item_id(i)
              index = i
              break
            end
          end
          assert_equal(#{reference_id}, @#{app}.#{arg}(index))
          @#{app}.delete(index)
        end
      ")
  end
end

=end