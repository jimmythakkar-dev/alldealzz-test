class AddIsBrandStoreToStores < ActiveRecord::Migration
  def change
    add_column :stores, :is_brand_store, :boolean, default: false
  end
end
