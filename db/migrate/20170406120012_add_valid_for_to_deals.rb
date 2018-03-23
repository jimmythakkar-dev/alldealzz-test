class AddValidForToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :valid_for, :integer
  end
end
