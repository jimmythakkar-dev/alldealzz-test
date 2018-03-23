class AddColumnsToEndUsersAndDeals < ActiveRecord::Migration
  def change
    add_column :end_users, :phone_number, :string
    add_column :end_users, :phone_verified, :boolean, default: false
    add_column :deals, :max_quantity, :integer
    add_column :deals, :quantity_per_user, :integer
    add_column :deals, :commission_percent, :decimal
    add_column :deals, :tax_percent, :decimal
    add_column :deals, :internet_handling_charges, :float
    add_column :deals, :approx_date_flag, :boolean, default: false
  end
end
