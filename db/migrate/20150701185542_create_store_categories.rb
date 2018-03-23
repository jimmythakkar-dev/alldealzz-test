class CreateStoreCategories < ActiveRecord::Migration
  def change
    create_table :store_categories do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
