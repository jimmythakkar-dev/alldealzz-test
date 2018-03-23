class StoreCategory < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
	validates :description, length: { maximum: 500 }
	
	has_many :store
end
