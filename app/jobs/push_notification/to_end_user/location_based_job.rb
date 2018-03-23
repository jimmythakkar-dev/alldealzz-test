class PushNotification::ToEndUser::LocationBasedJob < ActiveJob::Base
  queue_as :default

  def perform(token, lat, lng, store_ids = [], outlet_ids = [])
    user = token.resource_owner
    notify_deals = []
    deal_limit = 5
    after_hour = 3

  	if user && token.notification_status?     
      # *************************************************
      # Start : Find notifiable deals
      # *************************************************
      deal_notifications = token.oauth_access_token_deal_notifications
      last_deal_notification_time = if (_deal_notification = deal_notifications.order('created_at').last.try(:created_at)).present?
        _deal_notification
      else
        # In case of no deal_notification,
        # Removed extra time, Just to fulfill next condition. 
        Time.zone.now - (after_hour + 1).hour
      end

      # Checking, Next notify should be after `after_hour`
      if (last_deal_notification_time + after_hour.hour) <= Time.zone.now
        # Keep location for notification on all stores to be 250m and malls 500m
        # store_ids = Store.where('id in (?)', store_ids).select do |store| 
        #   store.in_radius?(lat, lng, 0.25)
        # end.map(&:id)
        
        # *************************************************
  	    # Start : Find deals 
        # *************************************************
  	    gender = {"male" => 0, "female" => 1}
  	    deals = Deal.click_notify_allowed_deals(nil, [Deal::DealType[:rd], Deal::DealType[:ed], Deal::DealType[:pd]]).
  	        age_gender_deals(user.age, gender[user.gender]).
  	        interested_deals(user.deal_categories.map(&:id)).at_days
        store_deals = deals.without_outlets.where('deals.store_id in (?)', store_ids)
        outlet_deals = deals.with_outlets.where('outlets.id in (?)', outlet_ids)

        deals = (store_deals + outlet_deals).uniq
  	    logger.debug "~~ Notify deals ~~~~~~~~~~~~~~~~~~~~ #{deals.map(&:id)}"

  	    deals.each do |deal|
          # Limiting deals to notify
          if notify_deals.size < deal_limit
            deal_notification = deal_notifications.find_or_create_by(deal_notification: deal)
            notify_deals << deal if deal_notification.notifiable_deal_by_type?(:weekly)
          end
  		  end
        logger.debug "++ Final notify deals +++++++++++++ #{notify_deals.map(&:id)}"
        # End : Find deals
        # *************************************************


        # *************************************************
        # Start : Notify
        # *************************************************
        notify_deals.each do |deal|
          deal.send_push_notification(token, lat, lng)
        end
        # End : Notify
        # *************************************************
      end  
	    # End : Find notifiable deals
      # *************************************************
    end 	
    notify_deals
  end
end
