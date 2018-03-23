json.deals deals do |deal|
  json.id deal.id
  json.title deal.title
  json.deal_type deal.deal_type_to_s
  json.no_of_bookings deal.booking_holders.count
end
