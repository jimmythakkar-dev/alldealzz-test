class AddApproxArrivalDateToEndUserUsedDeals < ActiveRecord::Migration
  def change
    add_column :end_user_used_deals, :approx_arrival_date, :date
  end
end
