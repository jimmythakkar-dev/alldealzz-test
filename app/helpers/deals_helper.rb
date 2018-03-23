module DealsHelper
  def show_outlets(deal)
    deal.outlets.pluck(:locality).join(',') if deal.outlets.present?
  end
end
