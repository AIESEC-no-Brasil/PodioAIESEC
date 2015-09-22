require 'active_record'

class ApproachChannel < ActiveRecord::Base
  enum status: {email: 1,
                whatsapp: 2,
                cellphone: 3,
                facebook: 4}
end