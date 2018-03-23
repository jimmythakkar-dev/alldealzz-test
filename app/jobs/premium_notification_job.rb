# NOTE : Not Used

class PremiumNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(token, lat, lng, *args)
  	user = token.resource_owner
	  notify_pns = []

  	if user && token.notification_status?
	    # Stores
	    stores = Store.enabled.have_premium_notification_quota

	    logger.debug "==2=notify_pns===stores==> #{stores.map(&:id)}"

	    # Find pns
	    pns = PremiumNotification.where('stores.id in (?)', stores.pluck(:id)).
	      notify_allowed_pns.
	      interested_pns(user.deal_categories.map(&:id)).
	      at_days.select do |pn| 
	      pn.in_radius?(lat,lng)
	    end.flatten.compact

	    logger.debug "==2=notify_pns===pns==> #{pns.map(&:id)}"

	    # Find notifiable pns
	    pns.each do |pn|
	      if user.premium_notifications.exclude?(pn)
	        user.end_user_premium_notifications.create(
	        premium_notification: pn, aday: true, count: 1)
	      else
	        notify = user.end_user_premium_notifications.find_by_premium_notification_id(pn.id)
	        notify_pns << pn if notify.present? && notify.notifiable_premium_notification? 
	      end 
	    end

	    premium_notifications = user.end_user_premium_notifications.where('premium_notification_id not in (?)', notify_pns.map(&:id))
	    premium_notifications.delete_all

	    logger.debug "==2=notify_pns==final pns==> #{notify_pns.map(&:id)}"

	    # Notify
	    notify_pns.each do |pn|
		    pn.send_push_notification(token, lat, lng)
	    end
    end
    notify_pns
  end
end
