class AddColumnsToStore < ActiveRecord::Migration
  def change
    add_column :stores, :start_time, :time, default: "00:00:00"
    add_column :stores, :end_time, :time, default: "23:59:59"
  end
end
