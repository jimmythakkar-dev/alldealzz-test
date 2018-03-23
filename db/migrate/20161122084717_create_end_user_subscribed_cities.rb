class CreateEndUserSubscribedCities < ActiveRecord::Migration
  def change
    create_table :end_user_subscribed_cities do |t|
      t.integer :end_user_id
      t.integer :city_id

      t.timestamps null: false
    end
  end
end
