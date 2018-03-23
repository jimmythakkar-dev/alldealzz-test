json.points_history @points_histories do |points_history|
	user_message = "Points Recevied from All Dealzz"
	cashback_message = "Points Recevied for code " + points_history.cashback.try(:code).to_s
	deal_cashback_message = "Cashback Recevied for deal " + points_history.deal.try(:main_line).to_s
json.id points_history.id
json.title points_history.deal.main_line + " bought"  if points_history.deal_id.present? && !points_history.cashback_id.present?
json.title cashback_message if !points_history.deal_id.present? && points_history.cashback_id.present?
json.title user_message if points_history.user_id.present?
json.title deal_cashback_message if points_history.deal_id.present? && points_history.cashback_id.present?
json.points points_history.points.round(2)
json.history_points_type points_history.history_points_type
json.date points_history.created_at.strftime('%a, %d %b %Y') rescue nil
end
json.status status