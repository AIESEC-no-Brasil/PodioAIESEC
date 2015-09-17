require 'active_record'

class BooleanEnum < ActiveRecord::Base
  enum status: {no: 1,
                yes: 2}
end