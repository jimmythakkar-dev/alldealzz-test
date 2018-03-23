class AddSalesUserStoresFiels < ActiveRecord::Migration
  def up
  	add_column :sales_user_stores, :owner_name, :string
  	add_column :sales_user_stores, :owner_contact_number, :string
  	rename_column :sales_user_stores, :authorized_person_name, :mgr_name
  	add_column :sales_user_stores, :mgr_contact_number, :string
  end

  def down
  	remove_column :sales_user_stores, :mgr_contact_number
  	rename_column :sales_user_stores, :mgr_name, :authorized_person_name
  	remove_column :sales_user_stores, :owner_contact_number
  	remove_column :sales_user_stores, :owner_name
  end
end
