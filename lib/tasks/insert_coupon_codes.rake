require 'csv'

namespace :coupon_codes do
	desc "Insert coupon codes"
  task :insert, [:merchant_id] => [:environment] do |t, args|
  	if (merchant_user = MerchantUser.find_by_id(args[:merchant_id])).present?
	  	csv_text = File.read("lib/tasks/features/coupon_codes_insert/#{args[:merchant_id]}.csv")
			csv = CSV.parse(csv_text, headers: true)
			csv.each do |row|
				booking_code = merchant_user.booking_codes.new(coupon_code: row[0].try(:strip))
        if booking_code.save
			  	puts "=> Created: #{row}"
			  end
			end	
		end	
	end
end	
