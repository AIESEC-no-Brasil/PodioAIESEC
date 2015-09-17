require 'active_record'

class Interest < ActiveRecord::Base
  enum status: {managerment: 1,
                teaching: 2,
                marketing: 3,
                engineering: 4,
                startups: 5}
end