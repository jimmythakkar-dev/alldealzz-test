class AddColumnsToEndUserPointsHistories < ActiveRecord::Migration
  def change
    add_column :end_user_points_histories, :cashback_id, :integer
    add_column :end_user_points_histories, :deal_id, :integer
    add_column :end_user_points_histories, :history_points_type, :integer, default: 0
  end
end
