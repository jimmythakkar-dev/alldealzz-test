class PushNotification::ToMerchantUser::DealBookingJob < ActiveJob::Base
  queue_as :default

  def perform(deal, app_type, text)
    store = deal.store
    outlets = deal.outlets
    to_notify = { type: 0, text: text, sender: deal, deal_id: deal.id, 
      title: deal.main_line, deal_type: deal.deal_type_to_s }
    
    # NOTE : Todo change deal_type_to_s in next version of merchant
    tokens = Doorkeeper::AccessToken.of_merchantable(store)
    outlets.each do |outlet|
      tokens << Doorkeeper::AccessToken.of_merchantable(outlet)
    end

    tokens = tokens.flatten.uniq { |i| i.pn_id }.select { |i| i.pn_id.present? }
    tokens.each do |token|
      token.send_push_notification(to_notify)
    end  
  end
end