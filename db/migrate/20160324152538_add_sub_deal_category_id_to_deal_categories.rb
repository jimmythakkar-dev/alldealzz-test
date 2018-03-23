class AddSubDealCategoryIdToDealCategories < ActiveRecord::Migration
  def change
    add_reference :deal_categories, :sub_deal_category
    add_index :deal_categories, :sub_deal_category_id
    # remove_column :deal_categories, :store_id, :integer
    create_table :deal_deal_categories do |t|
      t.references :deal
			t.references :deal_category

      t.timestamps null: false
    end
    add_index :deal_deal_categories, :deal_category_id
    add_index :deal_deal_categories, :deal_id
    add_index :deal_deal_categories, [:deal_id, :deal_category_id]

    Deal.all.each do |d|
      if d.deal_category_id && (dc = DealCategory.find(d.deal_category_id)).present?
        d.deal_categories = [dc]
        d.save
      end  
    end  
  end
end
