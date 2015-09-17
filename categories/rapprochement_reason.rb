require 'active_record'

class RapprochementReason < ActiveRecord::Base
  enum status: {didnt_return_first_contact: 1,
                registered_outside_timeline: 2}
end