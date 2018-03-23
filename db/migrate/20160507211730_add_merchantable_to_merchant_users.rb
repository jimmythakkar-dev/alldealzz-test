class AddMerchantableToMerchantUsers < ActiveRecord::Migration
  def up
  	rename_column :merchant_users, :store_id, :merchantable_id
  	add_column :merchant_users, :merchantable_type, :string
  	add_index :merchant_users, [:merchantable_id, :merchantable_type]
    MerchantUser.find_in_batches(batch_size: 100).with_index do |group, batch|
		  puts "Processing group ##{batch} : Adding store as merchantable"
			group.each { |merchant_user| merchant_user.update_attribute(:merchantable_type, "Store") }
			sleep(10)
		end  
  end

  def down
  	remove_index :merchant_users, [:merchantable_id, :merchantable_type]
  	remove_column :merchant_users, :merchantable_type
  	rename_column :merchant_users, :merchantable_id, :store_id
  end
end
