namespace :update_category_id_cashbacks do
	desc "update category_id in cashbacks"
	task update_category_id: :environment do
		Cashback.transaction do
			Cashback.all.find_in_batches(start: 1, batch_size: 100) do |cashback|
				cashback.each do |c|
					deal_id = c.deal_id
					if c.deal_id.present? && c.deal_category_id == nil
						category_id = c.deal.deal_categories.root_categories.first.id
						category_cashback = Cashback.where(deal_id: deal_id, cashback_type: 1)
						category_cashback.each do |c_cashback|
							c_cashback.update_attributes(deal_category_id: category_id)
							puts "=> Updated category_id =  deal_id: #{c.deal_id}, category_id: #{c.deal_category_id}"
						end
					end
				end
			end
		end
	end
end
