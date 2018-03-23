class Api::V1::SearchesController < Api::V1::BaseController
  before_action :end_user_authorize!
  
  def text
  	lat = params[:latitude]
    lng = params[:longitude]
    search_text = params[:search_text].to_s.downcase

    # malls = Mall.allowed_malls.where(['lower(malls.name) like ?', "%#{search_text}%"])
    stores = Store.allowed_stores.where(['lower(stores.name) like ?', "%#{search_text}%"])
    deals = Deal.click_notify_allowed_deals(nil, Deal::DealType[:rd]).where(['lower(deals.main_line) like ?', "%#{search_text}%"])
    
    results = []
    # results.concat malls.map { |mall| text_response(1, mall, mall.name) }
    results.concat stores.map { |store| text_response(2, store, store.name) }
    results.concat  deals.map { |deal| text_response(3, deal, deal.main_line) }
    render_success(results: results.compact.sort_by {|h| h[:text] })
  end

  private

  def text_response(type, resource, text)
  	{ type: type, id: resource.id, text: text }
  end
end
