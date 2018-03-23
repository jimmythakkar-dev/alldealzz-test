class AddEndUserIdToNotifications < ActiveRecord::Migration
  def change
    add_column :rails_push_notifications_notifications,
      :end_user_id, :integer
    add_column :rails_push_notifications_notifications,
      :sendible_id, :integer
    add_column :rails_push_notifications_notifications,
      :sendible_type, :string 
  end
end
