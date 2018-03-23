class MerchantUser < ActiveRecord::Base
  include UserIdentifiable

  belongs_to :merchantable, polymorphic: true
  has_many :booking_codes
  has_many :requested_notifications

  validates :merchantable, presence: true

  # NOTE  : Same in SalesUser, MerchantUser, EndUser. 
  #         Because used in RailsPushNotifications#resource_owners
  def profile_name
    name.present? ? name : identifier
  end

  def store
    if merchantable.is_a?(Outlet)
      merchantable.store
    elsif merchantable.is_a?(Store)
      merchantable
    end  
  end

  def outlet
    merchantable if merchantable.is_a?(Outlet)
  end

  def deals
    return Deal.all.where('id is null') unless store.present?
    if merchantable.is_a?(Outlet)
      merchantable.deals
    elsif merchantable.is_a?(Store)
      merchantable.deals
    end
  end

  def global_merchantable
    self.merchantable.to_global_id if self.merchantable.present?
  end

  def global_merchantable=(merchant)
    self.merchantable = GlobalID::Locator.locate merchant
  end

  # TODO: re-factor get_booking_code, transaction_details 
  def get_booking_code(end_user)
    coupon_code = "#{store.name.gsub(/\s+/, "").upcase[0..1]}#{SecureRandom.hex(2).upcase}"

    if new_record?
      BookingCode.create(coupon_code: coupon_code)
    elsif has_booking_codes?
      booking_codes.not_used.first
    else
      booking_codes.create(coupon_code: coupon_code)
    end
  end

  def transaction_details(settlement_status)
    deal_ids = deals.pluck(:id)
    tds = TransactionDetail.joins(:deal).where('deals.id in (?) AND transaction_details.payment_status = ? AND deals.commission_percent != ? AND transaction_details.refund = ?', deal_ids, 1, 100, false).used_only_deals
    case settlement_status 
    when 'unsettled'
      tds.unsettled
    when 'settled'
      tds.settled
    else
      tds
    end.order('created_at desc').select { |m| outlet.blank? || outlet.id == m.product_info.outlet_id.to_i }
  end
end
