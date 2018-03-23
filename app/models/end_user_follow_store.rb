class EndUserFollowStore < ActiveRecord::Base
  belongs_to :end_user
  belongs_to :follow_store, 
    class_name: "Store", foreign_key: "store_id"
  belongs_to :follow_end_user, 
    class_name: "EndUser", foreign_key: "end_user_id"

  validates :end_user_id, uniqueness: {scope: :store_id}
end
