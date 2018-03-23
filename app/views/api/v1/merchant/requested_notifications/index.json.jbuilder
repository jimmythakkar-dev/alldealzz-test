json.total_count @requested_notifications.total_count
json.partial! 'requested_notifications', requested_notifications: @requested_notifications
json.status status
