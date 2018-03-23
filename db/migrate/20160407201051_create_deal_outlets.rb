class CreateDealOutlets < ActiveRecord::Migration
  def change
    create_table :deal_outlets do |t|
      t.integer :deal_id
      t.integer :outlet_id

      t.timestamps null: false
    end
    add_index :deal_outlets, :outlet_id
    add_index :deal_outlets, :deal_id
    add_index :deal_outlets, [:outlet_id, :deal_id]
  end
end
