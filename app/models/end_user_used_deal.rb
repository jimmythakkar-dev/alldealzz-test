class EndUserUsedDeal < ActiveRecord::Base
  belongs_to :end_user
  belongs_to :deal
  belongs_to :used_deal, 
    class_name: "Deal", foreign_key: "deal_id"
  belongs_to :used_end_user, 
    class_name: "EndUser", foreign_key: "end_user_id"
  belongs_to :booking_code
  belongs_to :transaction_detail

  scope :allow_booking, -> {
    where('(end_user_used_deals.time_slot_start_time is not null and 
      end_user_used_deals.time_slot_end_time is not null and
      end_user_used_deals.time_slot_end_time::time >= ?) or 
      (end_user_used_deals.time_slot_start_time is null or 
      end_user_used_deals.time_slot_end_time is null)', 
      Time.zone.now.strftime("%H:%M:%S"))
  }
  scope :book_deals, -> {where("end_user_used_deals.booking_code_id is not null")}
  scope :transaction_refund, -> {
    joins(:transaction_detail).where("transaction_details.refund is false")
  }
  def redeemed?
  	booking_code.try(:redeemed?).present?
  end

  def refund?
    transaction_detail.try(:refund?).present?
  end 
  # NOTE : status
  # 1 : redeemed
  # 2 : used
  # 0 : not redeemed / not used
  # 3 : refunded
  def status
    refund? ? 3 : redeemed? ? 1 : (used_status? ? 2 : 0)
  end
  scope :male, -> {
    joins(:end_user).where(end_users: { gender: "male"}).pluck(:end_user_id).uniq
  }
  scope :female, -> {
    joins(:end_user).where(end_users: { gender: "female"}).pluck(:end_user_id).uniq
  }
  scope :not_specifed, -> {
    joins(:end_user).where(end_users: { gender: nil}).pluck(:end_user_id).uniq
  }
  scope :age_1, -> {
    joins(:end_user).where('end_users.age BETWEEN 17 AND 24').pluck(:end_user_id).uniq
  }
  scope :age_2, -> {
    joins(:end_user).where('end_users.age BETWEEN 24 AND 30').pluck(:end_user_id).uniq
  }
  scope :age_3, -> {
    joins(:end_user).where('end_users.age >= 30').pluck(:end_user_id).uniq
  }
  scope :age_4, -> {
    joins(:end_user).where('end_users.age is null').pluck(:end_user_id).uniq
  }
  scope :date_report, -> (from_date , end_date) {
    where("booking_code_id is not null AND (end_user_used_deals.created_at >= :from_date AND end_user_used_deals.created_at <= :end_date)", { from_date: from_date , end_date: end_date})
  }
end
