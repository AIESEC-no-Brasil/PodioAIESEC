require 'active_record'

class Semester < ActiveRecord::Base
  enum status: {s1: 1,
                s2: 2,
                s3: 3,
                s4: 4,
                s5: 5,
                s6: 6,
                s7: 7,
                s8: 8,
                s9: 9,
                s10: 10,
                completed: 12,
                other: 11}
end