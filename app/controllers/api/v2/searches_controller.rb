class Api::V2::SearchesController < Api::V2::BaseController
  before_action :end_user_authorize!
  include ActionView::Helpers::TextHelper


  # Currently the search results are based on two types
  # type : 2 (Store Name results)
  # type : 3 (Deal results)
  # With Outlet search in place three new types are needed
  # type : 4 (Outlet Store based on store name search)
  # Eg: search_text = "Dominos" Result ("Dominos 7 Outlets)

  # type : 5 (Outlet Search Based on locality)
  # Eg: search_text = "Anandna" Result ("Dominos Anandnagar, CCD Anandnagar)

  # type : 6 (Outlet Deal Results)
  # Eg search_text = "20% Off" Result (All Outlet Deals containing Mainline as 20% off and also outlet_id along with the deal)

  # type : 7 (Last Minute Deal Results)
  # type : 8 (LMD outlet Deal Results)

  # type 2 will not contain any stores which has outlets and type 3 will not contain any deals which are outlet deals.
  def text
  	lat = params[:latitude]
    lng = params[:longitude]
    city_filter = current_user_city
    search_text = params[:search_text].to_s.downcase
    main_limit = 20

    # malls = Mall.allowed_malls.where(['lower(malls.name) like ?', "%#{search_text}%"])
    stores = Store.without_outlets.group('stores.id').allowed_stores(city_filter)
      .where(['lower(stores.name) like ?', "%#{search_text}%"])
      .select('stores.id, stores.name')
      .reorder('stores.name').limit(main_limit)
  	deals = Deal.without_outlets.group('deals.id').click_notify_allowed_deals(city_filter, [Deal::DealType[:rd], Deal::DealType[:ed], Deal::DealType[:pd]])
      .where(['lower(deals.main_line) like ?', "%#{search_text}%"])
      .select('deals.id, deals.main_line')
      .reorder('deals.main_line').limit(main_limit)
    outlet_stores = Store.with_outlets.group('stores.id').allowed_stores(city_filter)
      .where(['lower(stores.name) like ?', "%#{search_text}%"])
      .select('stores.id, stores.name')
      .reorder('stores.name').limit(main_limit)
    outlets = Outlet.allowed_outlets(city_filter)
      .where(['lower(outlets.locality) like ?', "%#{search_text}%"])
      .select('outlets.id, outlets.locality, outlets.store_id')
      .reorder('outlets.locality').limit(main_limit)
    outlet_deals = Deal.with_outlets.group('deals.id').click_notify_allowed_deals(city_filter, [Deal::DealType[:rd], Deal::DealType[:ed], Deal::DealType[:pd]])
      .where(['lower(deals.main_line) like ?', "%#{search_text}%"])
      .select('deals.id, deals.main_line')
      .reorder('deals.main_line').limit(main_limit)
    lmd_deals = Deal.without_outlets.click_notify_allowed_deals(city_filter, Deal::DealType[:lmd]).in_last_minute_deal_time
       .where(['lower(deals.main_line) like ?', "%#{search_text}%"])
       .select('deals.id, deals.main_line, deals.last_end_time')
       .reorder('deals.main_line').limit(main_limit)
    lmd_outlet_deals = Deal.with_outlets.group('deals.id').click_notify_allowed_deals(city_filter, Deal::DealType[:lmd]).in_last_minute_deal_time
        .where(['lower(deals.main_line) like ?', "%#{search_text}%"])
        .select('deals.id, deals.main_line, deals.last_end_time')
        .reorder('deals.main_line').limit(main_limit)

    results = []
    # results.concat malls.map { |mall| text_response(1, mall, mall.name) }
    results.concat stores.map { |store| text_response(2, store, store.name) }
    results.concat  deals.map { |deal| text_response(3, deal, deal.main_line) }
    results.concat  outlet_stores.map { |store| text_response(4, store, store.local_name ) }
    results.concat  outlets.map { |outlet| text_response(5, outlet, outlet.local_name) }
    results.concat(outlet_deals.map do |deal|
      deal.outlets.map { |outlet| text_response(6, deal, deal.main_line, { outlet_id: outlet.id }) }
                   end.flatten)
    results.concat  lmd_deals.map { |deal| text_response(7, deal, deal.main_line, { time_difference: deal.lmd_time_difference.strftime("%H:%M") }) }
    results.concat(lmd_outlet_deals.map do |deal|
                     deal.outlets.map { |outlet| text_response(8, deal, deal.main_line, { outlet_id: outlet.id, time_difference: deal.lmd_time_difference.strftime("%H:%M") }) }
                   end.flatten)
    render_success(results: results.compact.sort_by {|h| h[:text] }.first(main_limit))
  end

  private

  def text_response(type, resource, text, options = {})
  	{ type: type, id: resource.id, text: text }.merge(options)
  end
end
