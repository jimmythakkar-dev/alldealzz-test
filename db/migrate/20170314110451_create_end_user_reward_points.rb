class CreateEndUserRewardPoints < ActiveRecord::Migration
  def change
    create_table :end_user_reward_points do |t|
    	t.integer :end_user_id
    	t.float :points
	    t.timestamps null: false
    end
  end
end

