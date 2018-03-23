json.deals deals do |deal|
  json.id deal.id
  json.title deal.title
  json.deal_type deal.deal_type_to_s
  json.deal_status deal.approved? ? "Approved" : "Pending For Approval"
end