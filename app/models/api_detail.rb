class ApiDetail < ActiveRecord::Base
	DeviceType = { google: false, apple: true}
	AppType = { normal: "1", forcefully: "2"}
	
	validates :app_version, :presence => true, 
            :uniqueness => { :allow_blank => true, :case_sensitive => false }
	def device_type_to_s
		case device_type
		when DeviceType[:google]
			"Google"
		when DeviceType[:apple]
			"Apple"
		end
	end

	def app_type_to_s
		case app_type
		when AppType[:normal]
			"Normal"
		when AppType[:forcefully]
			"Forcefully"
		end
	end
end
