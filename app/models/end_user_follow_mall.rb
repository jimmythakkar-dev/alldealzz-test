class EndUserFollowMall < ActiveRecord::Base
  belongs_to :end_user
  belongs_to :follow_mall, 
    class_name: "Mall", foreign_key: "mall_id"
  belongs_to :follow_end_user, 
    class_name: "EndUser", foreign_key: "end_user_id"

  validates :end_user_id, uniqueness: {scope: :mall_id} 
end

