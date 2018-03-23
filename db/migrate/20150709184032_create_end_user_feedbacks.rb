class CreateEndUserFeedbacks < ActiveRecord::Migration
  def change
    create_table :end_user_feedbacks do |t|
    	t.integer :end_user_id, null: false
    	t.text :message

      t.timestamps null: false
    end
  end
end
