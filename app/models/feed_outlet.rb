class FeedOutlet < ActiveRecord::Base
  belongs_to :feed
  belongs_to :outlet
end
