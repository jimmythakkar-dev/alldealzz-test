class AddColumnToTransactionDetails < ActiveRecord::Migration
  def change
  	add_column :transaction_details, :cashback_id, :integer
  	add_column :transaction_details, :points, :float
  end
end
