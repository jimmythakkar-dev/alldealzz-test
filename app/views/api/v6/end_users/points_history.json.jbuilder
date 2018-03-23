json.points_history @points_histories do |points_history|
	# cashback_message = "Points Recevied for code " + points_history.cashback.try(:code).to_s
	# deal_cashback_message = "Cashback Recevied for deal " + points_history.deal.try(:main_line).to_s
	refunded_message = "Refund Received "
	user_message = "Points Received from All Dealzz"
	cashback_message = "Cashback Received"
	paid_amount = points_history.transaction_detail.try(:total_amount) - (points_history.points.round(2)) rescue 0
	json.id points_history.id
	if points_history.history_points_type.eql?(0)	
		json.id points_history.id
		json.points points_history.points.round(2)
		json.points_status points_history.points_status
		json.txn_type points_history.history_points_type
		json.deal points_history.deal.try(:main_line).to_s if points_history.deal_id.present?
		json.title cashback_message if !points_history.deal_id.present? && points_history.cashback_id.present?
		json.title user_message if points_history.user_id.present?
		json.title cashback_message if points_history.deal_id.present? && points_history.cashback_id.present?
		json.date_time points_history.created_at.strftime('%a, %d %b %Y') rescue nil
	
	elsif points_history.history_points_type.eql?(1) || points_history.history_points_type.eql?(3) || points_history.history_points_type.eql?(2)
		json.title refunded_message if points_history.history_points_type.eql?(2)
		json.title points_history.deal.main_line + " bought"  if points_history.deal_id.present? && !points_history.cashback_id.present?
		json.points points_history.points.round(2)
		json.points_status points_history.points_status
		json.txn_type points_history.history_points_type 
		if points_history.deal_id.present?
			json.deal points_history.deal.try(:main_line).to_s 
			json.store points_history.deal.store.try(:name).to_s
			json.discount_text "" 
			json.deal_price points_history.deal.discounted_price
		end
		json.deal_quantity points_history.transaction_detail.try(:quantity)
		json.transaction_id points_history.transaction_detail.try(:id)
		total_amount = ((points_history.transaction_detail.try(:total_amount).to_f).present? ? points_history.transaction_detail.try(:total_amount).to_f : points_history.points.round(2)) rescue 0
		json.total_amount total_amount
		json.amount_paid paid_amount.to_f
		json.date_time points_history.transaction_detail.created_at.strftime('%a, %d %b %Y') if points_history.history_points_type.eql?(3) || points_history.history_points_type.eql?(1) rescue nil	 
		json.date_time points_history.transaction_detail.updated_at.strftime('%a, %d %b %Y') if points_history.history_points_type.eql?(2) rescue nil	 
	end
end
json.status status