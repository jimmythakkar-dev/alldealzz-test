class AddClubMembershipColumnToEndUser < ActiveRecord::Migration
  def change
    add_column :end_users, :club_membership_detail_id, :integer
    add_column :end_users, :voucher_code_detail_id, :integer
    add_column :end_users, :membership_expiry_date, :date
  end
end
