class EndUserCategory < ActiveRecord::Base
	belongs_to :end_user
	belongs_to :deal_category

	validates :end_user_id, uniqueness: {scope: :deal_category_id}
	
end
