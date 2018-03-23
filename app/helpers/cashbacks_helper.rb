module CashbacksHelper
	def update_status(cashback)
		if !cashback.allowed? && cashback.status == true
			cashback.update_attributes(status: false)
		end
	end
end