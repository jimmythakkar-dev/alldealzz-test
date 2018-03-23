class VoucherCodeDetail < ActiveRecord::Base
  has_one :end_user
  belongs_to :club_membership_detail
end
