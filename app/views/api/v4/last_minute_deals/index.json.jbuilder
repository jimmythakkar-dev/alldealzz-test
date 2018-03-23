json.total_count @deals.total_count
json.is_club_member current_user.is_club_member?
json.partial! 'deals', deals: @deals, steps: true, sponsored: false
json.status status
