class AddPhotoUrlToEndUsers < ActiveRecord::Migration
  def change
    add_column :end_users, :photo_url, :text
  end
end
