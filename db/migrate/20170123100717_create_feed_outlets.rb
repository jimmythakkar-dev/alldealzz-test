class CreateFeedOutlets < ActiveRecord::Migration
  def change
    create_table :feed_outlets do |t|
      t.integer :feed_id
      t.integer :outlet_id

      t.timestamps null: false
    end
    add_index :feed_outlets, :outlet_id
    add_index :feed_outlets, :feed_id
    add_index :feed_outlets, [:outlet_id, :feed_id]
  end
end
