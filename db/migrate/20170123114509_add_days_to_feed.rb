class AddDaysToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :days, :string
  end
end
