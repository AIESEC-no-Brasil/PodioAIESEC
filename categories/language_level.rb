require 'active_record'

class LanguageLevel < ActiveRecord::Base
  enum status: {unknown: 4,
                basic: 1,
                intermediate: 2,
                advanced: 3}
end