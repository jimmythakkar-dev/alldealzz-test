module ApplicationHelper
	def title_header(store, small_text = "")
    main_text = if current_user && current_user.store_admin?
		  store.name.try(:capitalize)
		end
    content_tag :h3  do 
    	if main_text
    	  content_tag(:x, "#{main_text}") + " - "
    	else
    	  content_tag(:x, small_text) + " - "
    	end + content_tag(:x, "#{Settings.app_name} Solutions")
    end	 
	end

  def home_active_links(list, active, middle = '')
    if active.present?
      home = li_link_to('Home', root_path)
      list.insert(0, home)
      active = li_link_to active, nil, class: "active"
      list.join('').html_safe + middle + active
    else
      list.join('').html_safe + middle
    end  
  end  

  def store_breadcrumb_list(store, active, index = false)
    list = []
    manageable = store.try(:manageable) || @manageable

    list << mall_breadcrumb_list(manageable, nil)

    if (index || store.is_a?(Store)) && can?(:index, Store)
      s_path = manageable.present? ? mall_stores_path(manageable) : stores_path
      list << li_link_to('Stores', s_path)
    end
    if store.is_a?(Store) && can?(:dashboard, store)
      list << li_link_to(store.name.capitalize, store_dashboard_path(store))
    end
    
    home_active_links(list, active, block_given? ? yield : '')
  end

  def outlet_breadcrumb_list(outlet, active, index = false)
    list = []
    store = outlet.try(:store) || @store

    list << store_breadcrumb_list(store, nil)

    if (index || outlet.is_a?(Outlet)) && can?(:index, Outlet)
      list << li_link_to('Outlets', store_outlets_path(store))
    end
    if outlet.is_a?(Outlet) && can?(:show, outlet)
      list << li_link_to(outlet.locality.capitalize, [store, outlet])
    end

    home_active_links(list, active, block_given? ? yield : '')
  end

  def deal_breadcrumb_list(deal, active, index = false)
    list = []
    store = deal.try(:store) || @store

    list << store_breadcrumb_list(store, nil)

    if (index || deal.is_a?(Deal)) && can?(:index, Deal)
      list << li_link_to('Deals', store_deals_path(store))
    end
    if deal.is_a?(Deal) && can?(:show, deal)
      list << li_link_to(deal.main_line.capitalize, [store, deal])
    end

    home_active_links(list, active, block_given? ? yield : '')  
  end

  def feed_breadcrumb_list(feed, active, index = false)
    list = []
    store = feed.try(:store) || @store

    list << store_breadcrumb_list(store, nil)

    if (index || feed.is_a?(Feed)) && can?(:index, Feed)
      list << li_link_to('Feeds', store_feeds_path(store))
    end
    if feed.is_a?(Feed) && can?(:show, feed)
      list << li_link_to(feed.title.capitalize, [store, feed])
    end

    home_active_links(list, active, block_given? ? yield : '')  
  end

  def pn_breadcrumb_list(pn, active, index = false)
    list = []
    store = pn.try(:store) || @store

    list << store_breadcrumb_list(store, nil)

    if (index || pn.is_a?(PremiumNotification)) && can?(:index, PremiumNotification)
      list << li_link_to('Premium Notifications', 
          store_premium_notifications_path(store))
    end
    if pn.is_a?(PremiumNotification) && can?(:show, pn)
      list << li_link_to( pn.notification_text.capitalize, 
        [store, pn])
    end

    home_active_links(list, active, block_given? ? yield : '')  
  end

  def mall_breadcrumb_list(manageable, active, index = false)
    list = []
    if (index || manageable.is_a?(Mall)) && can?(:index, Mall)
      list << li_link_to('Malls', malls_path)
    end
    if manageable.is_a?(Mall) && can?(:show, manageable)
      list << li_link_to(manageable.name.capitalize, mall_dashboard_path(manageable))
    end
    home_active_links(list, active, block_given? ? yield : '')  
  end
  
  def cashback_breadcrumb_list(cashback, active, index = false)
    list = []
    if (index || cashback.is_a?(Cashback)) && can?(:index, Cashback)
      list << li_link_to('Cashbacks', cashbacks_path)
    end
    if cashback.is_a?(Cashback) && can?(:show, cashback)
      list << li_link_to(cashback.text.capitalize, [cashback])
    end
    home_active_links(list, active, block_given? ? yield : '')  
  end

  def api_detail_breadcrumb_list(api_detail, active, index = false)
    list = []
    if (index || api_detail.is_a?(ApiDetail)) && can?(:index, ApiDetail)
      list << li_link_to('API Details', api_details_path)
    end
    if api_detail.is_a?(ApiDetail) && can?(:show, api_detail)
      list << li_link_to(api_detail.id, [api_detail])
    end
    home_active_links(list, active, block_given? ? yield : '')  
  end

  def end_user_breadcrumb_list(end_user, active, index = false)
    list = []
    if (index || end_user.is_a?(EndUser)) && can?(:index, EndUser)
      list << li_link_to('EndUsers', end_users_path)
    end
    if end_user.is_a?(EndUser) && can?(:show, end_user)
      list << li_link_to(end_user.name.capitalize, [end_user])
    end
    home_active_links(list, active, block_given? ? yield : '')  
  end

  def sales_user_breadcrumb_list(sales_user, active, index = false)
    list = []
    if (index || sales_user.is_a?(SalesUser)) && can?(:index, SalesUser)
      list << li_link_to('Sales Users', sales_users_path)
    end
    home_active_links(list, active, block_given? ? yield : '')   
  end

  def sales_user_store_breadcrumb_list(sales_user_store, active, index = false)
    list = []
    sales_user = sales_user_store.sales_user
    if (index || sales_user.is_a?(SalesUser)) && can?(:index, SalesUser)
      list << li_link_to('Sales Users', sales_users_path)
    end
    if (index || sales_user_store.is_a?(SalesUserStore)) && can?(:index, SalesUserStore)
      list << li_link_to('Sales User Stores', sales_user_path(sales_user))
    end
    home_active_links(list, active, block_given? ? yield : '')   
  end

  def merchant_user_breadcrumb_list(merchant_user, active, index = false)
    list = []
    if (index || merchant_user.is_a?(MerchantUser)) && can?(:index, MerchantUser)
      list << li_link_to('Merchant Users', merchant_users_path)
    end
    if merchant_user.is_a?(MerchantUser) && can?(:show, merchant_user)
      list << li_link_to(merchant_user.profile_name.capitalize, [merchant_user])
    end
    home_active_links(list, active, block_given? ? yield : '')   
  end  

  def li_link_to(name, path, li_options = {}, link_options = {})
    content_tag :li, li_options  do 
      path.present? ? link_to(name, path, link_options) : name
    end
  end

  def default_logo_image
      image_tag('logo/logo_fandy.png', alt: "#{Settings.app_name} Solutions", class: "navbar-logo logo-medium", style: "height: 4em; width: 10em;")
  end
end
