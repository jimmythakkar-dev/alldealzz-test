class BookingCode < ActiveRecord::Base
  belongs_to :merchant_user

  has_one :end_user_used_deal, dependent: :destroy
  has_one :end_user, through: :end_user_used_deal

  scope :not_used, -> {
      joins('LEFT JOIN end_user_used_deals ON end_user_used_deals.booking_code_id = booking_codes.id').where('end_user_used_deals.id is null')
  }
  validates_uniqueness_of :coupon_code

  def redeemed_deal
    self.transaction do
      self.update_attributes(redeemed: true, redeemed_at: Time.zone.now)
      end_user_used_deal.update_attribute('used_status',true)
      end_user_used_deal
    end
  end
end
