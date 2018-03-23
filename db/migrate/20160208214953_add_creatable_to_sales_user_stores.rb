class AddCreatableToSalesUserStores < ActiveRecord::Migration
  def change
    add_reference :sales_user_stores, :creatable, polymorphic: true, index: true
  end
end
