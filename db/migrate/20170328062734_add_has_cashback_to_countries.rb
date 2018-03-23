class AddHasCashbackToCountries < ActiveRecord::Migration
  def change
  	add_column :countries, :has_cashback, :boolean
  end
end
