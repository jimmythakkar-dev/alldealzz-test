json.total_count @feeds.total_count
json.is_club_member current_user.is_club_member?
json.partial! 'feeds', feeds: @feeds
json.status status
