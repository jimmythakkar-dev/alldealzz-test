class AddRefundToTransactionDetails < ActiveRecord::Migration
  def change
  	add_column :transaction_details, :refund, :boolean, default: false
  end
end
