class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name
      t.string :server_url
      t.string :logo_url
      t.string :isd_code
      t.boolean :has_exclusive_club
      t.boolean :has_brands

      t.timestamps null: false
    end
  end
end
