class CreateEndUserPointsHistories < ActiveRecord::Migration
  def change
    create_table :end_user_points_histories do |t|
    	t.integer :end_user_id
    	t.integer :user_id
    	t.float :points
      t.timestamps null: false
    end
  end
end
