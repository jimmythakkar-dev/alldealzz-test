class DealDealCategory < ActiveRecord::Base
  belongs_to :deal_category
  belongs_to :deal
end
