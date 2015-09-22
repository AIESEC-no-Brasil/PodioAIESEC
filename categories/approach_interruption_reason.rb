require 'active_record'

class ApproachInterruptionReason < ActiveRecord::Base
  enum status: {do_not_return_contact: 1,
                give_up_join_AIESEC: 2,
                registered_at_wrong_program: 3}
end