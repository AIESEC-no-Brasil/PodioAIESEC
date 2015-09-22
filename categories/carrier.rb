require 'active_record'

class Carrier < ActiveRecord::Base
  enum status: {claro: 1,
                tim: 2,
                oi: 3,
                vivo: 4,
                another: 5}
end