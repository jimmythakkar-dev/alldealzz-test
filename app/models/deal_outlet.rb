class DealOutlet < ActiveRecord::Base
	belongs_to :deal
	belongs_to :outlet
end
