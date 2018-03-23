class CreateEndUserCategories < ActiveRecord::Migration
  def change
    create_table :end_user_categories do |t|
    	t.integer :end_user_id, null: false
    	t.integer :store_category_id, null: false

      t.timestamps null: false
    end
    add_index :end_user_categories, :end_user_id
    add_index :end_user_categories, :store_category_id
    add_index :end_user_categories, [:end_user_id, :store_category_id], unique: true
  end
end
