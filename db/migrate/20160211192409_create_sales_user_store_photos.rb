class CreateSalesUserStorePhotos < ActiveRecord::Migration
  def change
    create_table :sales_user_store_photos do |t|
    	t.references :sales_user_store
    	t.attachment :photo

      t.timestamps null: false
    end
  end
end
