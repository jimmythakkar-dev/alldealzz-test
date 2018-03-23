class AddTargetCategoryIdToRequestedNotifications < ActiveRecord::Migration
  def change
    add_column :requested_notifications, :target_deal_category_id, :integer
  end
end
