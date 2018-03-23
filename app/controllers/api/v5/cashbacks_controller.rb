class Api::V5::CashbacksController < Api::V5::BaseController
	before_action :end_user_authorize!
	
  def index
		lat = params[:latitude].to_f
		lng = params[:longitude].to_f

		@cashbacks = cashbacks_result(lat, lng).page(params[:page]).per(10)
    render_success(template: :index)
	end
	
  def deal_cashback
    deal_id = params[:deal_id]
    @deal_cashbacks = Cashback.where(deal_id: deal_id).allowed_cashbacks
    deal = Deal.find(deal_id)
    @store = deal.store.cashbacks.store_cashbacks
    @category = deal.deal_categories.root_categories.first.cashbacks.deal_category_cashbacks
    
    @cashbacks = @deal_cashbacks.concat(@store.concat(@category))
		render_success(template: :deal_cashback)
	end
	
  def trending_cashbacks
		@trending_cashbacks = Cashback.trending_cashbacks.deal_cashbacks
		render_success(template: :trending_cashbacks)
	end
  
  def category_cashbacks
    index
  end

end

private
  # Filters are: type
  # 1-Popular(default)
  # 2-Nearby
  # 3-Ending Soon
  # 4-cashback 
  def cashbacks_result(lat, lng)
    category_ids = params[:category_id]
     city_filter = current_user_city
    _cashbacks = Cashback.cashbacks_listing
    type = [1,2,3,4].include?(params[:type].to_i) ? params[:type].to_i : 5

    if category_ids.present?
      _cashbacks = Cashback.where(deal_category_id: category_ids).allowed_cashbacks
    end
  	
    case type
  	when 1
  		popular_cashbacks = _cashbacks.sort_by { |cashback|
  			cashback.used_coupons
  		}.reverse
  		Kaminari.paginate_array(popular_cashbacks)
  	when 2
  		nearby_cashbacks = Cashback.deal_store_cashbacks.each { |c|
  			if c.store_id.present?
  			 c.steps = c.store.steps(lat, lng) 
  			else
  				c.steps = c.deal.store.steps(lat, lng) 
  			end	
  		}.sort_floating(:steps)
  		Kaminari.paginate_array(nearby_cashbacks)
  	when 3
      if params[:order].to_i == 0
        _cashbacks.order('expiry_date ASC')
      elsif params[:order].to_i == 1
        _cashbacks.order('expiry_date DESC')
      else
        _cashbacks.order('expiry_date ASC')
      end    
  	when 4
  		_cashbacks.order('discount DESC')
  	else
  		_cashbacks.order('created_at DESC')
  	end
  end