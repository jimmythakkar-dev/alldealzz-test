class AddEndUserAppliedCodeIdToTransactionDetail < ActiveRecord::Migration
  def change
  	add_column :transaction_details, :end_user_applied_code_id,  :integer
  end
end
