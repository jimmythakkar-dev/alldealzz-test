class EndUserFavourite < ActiveRecord::Base
  belongs_to :end_user
  belongs_to :favourite_deal, 
    class_name: "Deal", foreign_key: "deal_id"
  belongs_to :favourite_end_user, 
    class_name: "EndUser", foreign_key: "end_user_id"
    

	validates :end_user_id, uniqueness: {scope: :deal_id} 

	scope :male, -> {
		joins(:end_user).where(end_users: { gender: "male"}).pluck(:end_user_id).uniq
	}
	scope :female, -> {
		joins(:end_user).where(end_users: { gender: "female"}).pluck(:end_user_id).uniq
	}
	scope :not_specifed, -> {
		joins(:end_user).where(end_users: { gender: nil}).pluck(:end_user_id).uniq
	}
	scope :age_1, -> {
		joins(:end_user).where('end_users.age BETWEEN 17 AND 24').pluck(:end_user_id).uniq
	}
	scope :age_2, -> {
		joins(:end_user).where('end_users.age BETWEEN 24 AND 30').pluck(:end_user_id).uniq
	}
	scope :age_3, -> {
		joins(:end_user).where('end_users.age >= 30').pluck(:end_user_id).uniq
	}
	scope :age_4, -> {
		joins(:end_user).where('end_users.age is null').pluck(:end_user_id).uniq
	}
	scope :date_report, -> (from_date , end_date) {
    where("end_user_favourites.created_at >= :from_date AND end_user_favourites.created_at <= :end_date", { from_date: from_date , end_date: end_date})
  }
end
