class AddLmdDefaultImageToStores < ActiveRecord::Migration
  def change
    add_attachment :stores, :lmd_default_image
  end
end
