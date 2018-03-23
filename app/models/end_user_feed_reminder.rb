class EndUserFeedReminder < ActiveRecord::Base
  belongs_to :end_user
  belongs_to :feed

  belongs_to :feed_reminder,
    class_name: "Feed", foreign_key: "feed_id"
  belongs_to :end_user_reminder,
    class_name: "EndUser", foreign_key: "end_user_id"
end
