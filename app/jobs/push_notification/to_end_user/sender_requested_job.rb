class PushNotification::ToEndUser::SenderRequestedJob < ActiveJob::Base
  queue_as :default

  def perform(sender, text, filted_options = {}, options = {})
  	store, type, sender_options = find_store_and_type(sender)
    to_notify = { type: type, text: text, sender: sender }.merge(sender_options).merge(options)

    # Target access tokens
    targetAccessToken = if filted_options[:target_end_user_id].present?
      Doorkeeper::AccessToken.where(resource_owner_id: filted_options[:target_end_user_id])
    else
      Doorkeeper::AccessToken.all
    end  

    # Filter follower or all  
    notable_users_token = if store.present? && filted_options[:target_to] == 'followers'
	    targetAccessToken.store_followers(store)
    elsif filted_options[:target_to] == 'all'
    	targetAccessToken.of_end_users
    end

    if notable_users_token.present?
      # Distance filter
      if [filted_options[:merchant_user], filted_options[:target_distance]].all?
        merchant_user = filted_options[:merchant_user]
        if merchant_user.present?
          distance = filted_options[:target_distance] || 2.5
          notable_users_token = notable_users_token.in_distance(
              merchant_user.merchantable.latitude, 
              merchant_user.merchantable.longitude,
              distance, units: :km
            )
          
          # Removed followers 
          followers = Doorkeeper::AccessToken.store_followers(store)
          if followers.present?
            notable_users_token = notable_users_token.where.not(id: followers)
          end
        end
      end
    end

    # Final tokens
    if notable_users_token.present?
      notable_users_token.end_users_in_age(filted_options[:age_from], filted_options[:age_to])
       .end_users_of_gender(filted_options[:gender])
        .end_users_of_city(filted_options[:target_city_id])
        .end_users_of_root_deal_category(filted_options[:target_deal_category_id])
       .send_batche_push_notification(filted_options[:app_type].to_sym, 'EndUser', to_notify)
    end
  end

  private
  
  # NOTE 
  # return [store, type, sender_options]
  # type : 0 for deal, 1 for store, 3 for outlet, 2 for global
  def find_store_and_type(sender)
  	case sender.class.to_s
  	when 'Store'
  		store = sender
      [store, 1, { store_id: store.id, store_name: store.name }]
  	when 'Outlet'
      store = sender.store 
  		[store, 3, { outlet_id: sender.id, store_id: store.id, store_name: sender.local_name} ]
  	when 'Deal'
      # NOTE : Changed deal_type_to_s to deal_type
      store = sender.store 
  		[store, 0, { deal_id: sender.id, store_id: store.id, store_name: store.name, deal_type: sender.deal_type, deal_category_id: sender.try(:deal_category_ids).try(:first), feature_image: sender.featured_photo }]
  	when 'MerchantUser'
  		find_store_and_type(sender.merchantable)
  	when 'RequestedNotification'
  		find_store_and_type(sender.deal || sender.merchant_user || sender.merchantable)
  	else
  	  [nil, 2, {}]	
  	end
  end
end