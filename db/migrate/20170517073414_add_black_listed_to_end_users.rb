class AddBlackListedToEndUsers < ActiveRecord::Migration
  def change
  	add_column :end_users, :black_listed, :boolean, default: false
  end
end
