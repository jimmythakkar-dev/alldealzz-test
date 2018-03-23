class CreateDealCategories < ActiveRecord::Migration
  def change
    create_table :deal_categories do |t|
      t.integer :store_id
      t.string :name

      t.timestamps null: false
    end
  end
end
