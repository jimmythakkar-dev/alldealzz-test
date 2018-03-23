class AddRestrictPointsToDeal < ActiveRecord::Migration
  def change
    add_column :deals, :restrict_points, :boolean, default: false
  end
end
