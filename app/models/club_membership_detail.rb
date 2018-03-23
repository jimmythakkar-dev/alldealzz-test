class ClubMembershipDetail < ActiveRecord::Base
  has_many :end_users
  has_many :voucher_code_details
  has_many :membership_transaction_details

  PlanType = { 1 => 1.month, 2 => 3.months, 3 => 6.months, 4 => 1.year}
end
