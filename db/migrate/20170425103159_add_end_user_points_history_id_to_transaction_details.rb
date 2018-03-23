class AddEndUserPointsHistoryIdToTransactionDetails < ActiveRecord::Migration
  def change
    add_column :transaction_details, :end_user_points_history_id, :integer
  end
end
