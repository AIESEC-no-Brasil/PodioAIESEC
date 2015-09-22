require 'active_record'

class StudyStage < ActiveRecord::Base
  enum status: {some_college: 1,
                graduated: 2,
                incompete_graduate: 3,
                full_graduate: 4,
                master_phd: 5}
end