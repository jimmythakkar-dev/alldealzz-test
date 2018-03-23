json.booking_details bookings do |booking|
  json.customer_name booking.end_user.try(:profile_name)
  json.customer_email booking.end_user.try(:email)
  json.status booking.status
  json.phone_number booking.end_user.try(:phone_number)
  json.expected_time "#{booking.time_slot_start_time.try(:strftime, "%H:%M")}" " - " "#{booking.time_slot_end_time.try(:strftime, "%H:%M")}"
  json.approx_arr_date booking.approx_arrival_date
  json.no_of_guest booking.number_of_guests
  json.deal_quantity booking.try(:transaction_detail).try(:quantity)
  json.booking_codes booking.booking_code.coupon_code
  json.refunded booking.try(:transaction_detail).try(:refund)
end
