class AddPointsStatusToEndUserPointsHistories < ActiveRecord::Migration
  def change
  	add_column :end_user_points_histories, :points_status, :boolean, default: true
  end
end
