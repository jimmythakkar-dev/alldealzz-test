class CreateEndUserAppliedCodes < ActiveRecord::Migration
  def change
    create_table :end_user_applied_codes do |t|
    	t.integer :end_user_id
    	t.integer :cashback_id
      t.timestamps null: false
    end
  end
end
