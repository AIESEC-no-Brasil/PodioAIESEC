require 'active_record'

class MarketingChannel < ActiveRecord::Base
  enum status: {postal: 1,
                friends: 2,
                posters: 3,
                class_room: 4,
                junior_company: 5,
                events: 6,
                newspaper: 7,
                mailing: 8,
                flyer: 9,
                facebook: 10,
                global_village: 11,
                other: 12}
end