json.requested_notifications requested_notifications do |requested_notification|
  json.id requested_notification.id
  json.message requested_notification.message
  json.status requested_notification.aasm.current_state
  json.date requested_notification.updated_at.strftime('%a, %d %b %Y')
end
