class AddLmdCommissionPercentToStores < ActiveRecord::Migration
  def change
    add_column :stores, :lmd_commission_percent, :decimal, default: 10
  end
end
