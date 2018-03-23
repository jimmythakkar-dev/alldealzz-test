class AddLogoToStores < ActiveRecord::Migration
  def change
    add_attachment :stores, :logo
  end
end
