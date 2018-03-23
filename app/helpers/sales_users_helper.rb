module SalesUsersHelper
	def get_user_downloads(username)
		store = Store.find_by(name: username)
		if store.present?
			store.end_user_store_ref_codes.count
		else
			return "Not Found"	
		end	
	end	
end
