class EndUserAppliedCode < ActiveRecord::Base
	has_many :cashbacks
	belongs_to :end_user
	has_one :transaction_detail
end
