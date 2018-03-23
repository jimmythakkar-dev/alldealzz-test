json.total_count @bookings.total_count
json.partial! 'booking_details', bookings: @bookings
json.status status
