class EndUserFeedReview < ActiveRecord::Base
  belongs_to :end_user
  belongs_to :feed

  belongs_to :feed_review, 
    class_name: "Feed", foreign_key: "feed_id"
  belongs_to :end_user_review, 
    class_name: "EndUser", foreign_key: "end_user_id"
end
