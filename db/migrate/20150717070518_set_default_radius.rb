class SetDefaultRadius < ActiveRecord::Migration
  def up
    change_column_default :stores, :radius, 0
    change_column_default :premium_notifications, :radius, 0
  end
end
