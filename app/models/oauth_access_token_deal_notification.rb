class OauthAccessTokenDealNotification < ActiveRecord::Base
  belongs_to :oauth_access_token, 
    class_name: "Doorkeeper::AccessToken", foreign_key: "oauth_access_token_id"
  belongs_to :deal_notification, 
    class_name: "Deal", foreign_key: "deal_id"
  
  # on_request : On Nth request of today ( Default 1st request )
  # type accepts : :weekly(Default), :daily 
  def notifiable_deal_by_type?(type = :weekly, on_request = 1)
    off = { daily: 1, weekly: 7 }
    type_days = off[type]
    temp_count = count

    time_out = (created_at + type_days.days) <= Time.zone.now
    count_out = on_request <= temp_count
    temp_count = 0 if time_out && count_out
    temp_count += 1

    out = on_request == temp_count
    # out = time_out && count_out
    if out
      update_attributes(created_at: Time.zone.now, count: temp_count)
    else
      # if to remove extra update
      update_attributes(count: temp_count) if on_request > temp_count
    end
    out
  end
end
