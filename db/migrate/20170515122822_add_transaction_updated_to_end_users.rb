class AddTransactionUpdatedToEndUsers < ActiveRecord::Migration
  def change
  	add_column :end_users, :transaction_updated, :boolean, default: false
  end
end
