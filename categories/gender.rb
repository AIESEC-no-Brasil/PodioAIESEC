require 'active_record'

class Gender < ActiveRecord::Base
  enum status: {male: 1,
                female: 2}
end