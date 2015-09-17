require 'active_record'

class RapprochementNotes < ActiveRecord::Base
  enum status: {contact_at_next_seletive_process: 1,
                contact_at_next_ogip_hh: 2,
                contact_at_next_igip_hh: 3,
                contact_at_next_ogcdp_hh: 4,
                contact_at_next_igcdp_hh: 5,
                contact_at_next_fin_hh: 6,
                contact_at_next_mkt_hh: 7,
                contact_at_next_tm_hh: 8,
                contact_at_next_ep_hh: 9,
                contact_at_next_host_hh: 10}
end