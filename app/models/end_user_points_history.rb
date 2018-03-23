class EndUserPointsHistory < ActiveRecord::Base
	HistoryPointType = { positive: 0, negative: 1 }
	belongs_to :end_user
	belongs_to :user
	belongs_to :deal
	belongs_to :cashback
	has_one :transaction_detail
end
