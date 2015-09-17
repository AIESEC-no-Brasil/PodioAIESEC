require 'active_record'

class Priority < ActiveRecord::Base
  enum status: {p1: 1,
                p2: 2,
                p3: 3,
                p4: 4,
                p5: 5}
end