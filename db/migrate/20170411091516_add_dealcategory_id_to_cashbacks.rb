class AddDealcategoryIdToCashbacks < ActiveRecord::Migration
  def change
  	add_column :cashbacks, :deal_category_id, :integer
  end
end
