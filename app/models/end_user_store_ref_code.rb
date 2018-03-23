class EndUserStoreRefCode < ActiveRecord::Base
	 belongs_to :store
	 belongs_to :end_user
end
