class MembershipTransactionDetail < ActiveRecord::Base
  belongs_to :club_membership_detail
  belongs_to :end_user
end
