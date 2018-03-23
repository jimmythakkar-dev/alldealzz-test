class EndUserDealReview < ActiveRecord::Base
  belongs_to :end_user
  belongs_to :deal

  belongs_to :deal_review, 
    class_name: "Deal", foreign_key: "deal_id"
  belongs_to :end_user_review, 
    class_name: "EndUser", foreign_key: "end_user_id"
end
