class CreateEndUserStoreRefCodes < ActiveRecord::Migration
  def change
    create_table :end_user_store_ref_codes do |t|
      t.integer :end_user_id
      t.integer :store_id

      t.timestamps null: false
    end
  end
end
