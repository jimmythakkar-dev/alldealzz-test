# NOTE : Not Used

class DealsNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(token, lat, lng, *args)
  	user = token.resource_owner
    notify_deals = []

  	if user && token.notification_status?
	    stores = Store.in_distance(lat,lng).select do |store|
	      store.in_radius?(lat,lng)
	    end
	    
	    logger.debug "==1=notify_deals===stores==> #{stores.map(&:id)}"
	    
	    # Find deals
	    gender = {"male" => 0, "female" => 1}
	    deals = stores.map do |store| 
	      store.deals.click_notify_allowed_deals(nil, Deal::DealType[:rd]).
	        age_gender_deals(user.age, gender[user.gender]).
	        interested_deals(user.deal_categories.map(&:id)).
	     	at_days
	    end.flatten.compact

	    logger.debug "==1=notify_deals===deals==> #{deals.map(&:id)}"

	    # Find notifiable deals
	     deals.each do |deal|
		    if user.deal_notifications.exclude?(deal)
		      user.end_user_deal_notifications.create(
	          deal: deal, aday: true, count: 1)
		    else
		      notify = user.end_user_deal_notifications.find_by_deal_id(deal.id)
		      notify_deals << deal if notify.present? && notify.notifiable_deal? 
		    end	
		  end

	    deal_notifications = user.end_user_deal_notifications.where('deal_id not in (?)', notify_deals.map(&:id))
	    deal_notifications.delete_all

	    logger.debug "==1=notify_deals===final deals==> #{notify_deals.map(&:id)}"

	    # Notify
	    notify_deals.each do |deal|
		    deal.send_push_notification(token, lat, lng)
	    end
    end 	
    notify_deals
  end
end
