class CreateCashbacks < ActiveRecord::Migration
  def change
    create_table :cashbacks do |t|
    	t.integer  :cashback_type, default: 0
    	t.string   :text
    	t.float   :discount
    	t.string  :code
    	t.boolean :status, default: :false
      t.attachment :image
      t.integer  :deal_id
      t.integer  :store_id
      t.timestamps null: false
    end
  end
end
