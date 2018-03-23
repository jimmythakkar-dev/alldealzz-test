class AddRatingToEndUserDealReviews < ActiveRecord::Migration
  def change
    add_column :end_user_deal_reviews, :rating, :integer
  end
end
