class Quotum < ActiveRecord::Base
  belongs_to :store
  validates :total, :premium_notification_total, 
            numericality: true
  validates  :used, 
             numericality: { less_than_or_equal_to: :total }
  validates  :premium_notification_used, 
             numericality: { less_than_or_equal_to: :premium_notification_total }
end
