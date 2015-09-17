require 'active_record'

class BestMoment < ActiveRecord::Base
  enum status: {morning: 1,   #morning
                afternoon: 2,   #afternoon
                night: 3}  #night
end