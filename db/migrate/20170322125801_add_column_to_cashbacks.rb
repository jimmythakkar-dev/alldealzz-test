class AddColumnToCashbacks < ActiveRecord::Migration
  def change
  	add_column :cashbacks, :max_time_useable, :integer, default: 1
  	add_column :cashbacks, :points, :float
  	add_column :cashbacks, :publish_date, :datetime
  	add_column :cashbacks, :expiry_date, :datetime
  	add_column :cashbacks, :duration, :integer
  	add_column :cashbacks, :termsandconditions, :text
  	add_column :cashbacks, :is_trending, :boolean, default: false
  	add_column :cashbacks, :trending_order, :integer 
  end
end
