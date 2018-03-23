class AddDetailrelatedcolumnsInDeals < ActiveRecord::Migration
  def change
  	add_column :deals, :termsandconditions, :text
  	add_column :deals, :features, :text
  	add_column :stores, :locality, :string
  end
end
