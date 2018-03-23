class AddContactToEndUserFeedbacks < ActiveRecord::Migration
  def change
    add_column :end_user_feedbacks, :contact, :string
  end
end
