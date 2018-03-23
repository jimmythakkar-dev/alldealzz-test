class CreateVoucherCodeDetails < ActiveRecord::Migration
  def change
    create_table :voucher_code_details do |t|
      t.string :code
      t.references :club_membership_detail, index: true, foreign_key: true
      t.boolean :status, default: false

      t.timestamps null: false
    end
  end
end
