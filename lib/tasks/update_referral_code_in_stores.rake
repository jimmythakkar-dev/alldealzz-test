namespace :update_referral_code_in_stores do
	desc "Update Referral Codes in existing stores"
	task update_stores: :environment do
		Store.all.each do |store|
			name = store.name.present? ? store.name[0..1].upcase : "AD"
			randstr = SecureRandom.hex(2).upcase
			coupon_code = name + randstr
			store.update_attribute('referral_code',coupon_code)
			puts "#{store.name} Updated with code #{store.referral_code}" 
		end	
	end
end	