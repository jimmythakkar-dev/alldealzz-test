class Api::V6::TransactionDetailsController < Api::V6::BaseController
  before_action :end_user_authorize!
  before_action :get_deal_resource, except: [:index]
  skip_authorization_check only: :create_charge

  def new
    deal_id = params[:deal_id].to_i
    if @deal.exceeded_booking_limit?(current_user)
      render_error(422, "You have bought this deal max number of times")
    elsif @deal.expired?
      render_error(422, "Sorry, this deal has expired")
    else
      @gateway_id = params[:gateway_id].present? ? params[:gateway_id].to_i : 2
       end_user_reward_points = EndUserRewardPoint.find_by(end_user_id: current_user.id)
        if params[:points].present? && end_user_reward_points.present? && end_user_reward_points.points < params[:points].to_i
          render_error(422, "Please try again")
        else
          @transaction = @deal.create_transaction_detail(current_user,
            { cashback_id: params[:cashback_id], points: params[:points], quantity: params[:deal_quantity], total_amount: params[:total_amount], outlet_id: params[:outlet_id] })
          @transaction.cashback_settlement(current_user.id, deal_id)
          if @transaction.present?
            render_success(template: :new)
          else
            render_error(400, "Bad Request")
          end
      end  
    end
  end

  def index
    @transactions = current_user.transaction_details.order('id DESC').page(params[:page]).per(10)
    render_success(template: :index)
  end

  def create_charge
    Stripe.api_key = Settings.stripe.secret_key
    begin
      @charge = Stripe::Charge.create(
          :amount => (params[:amount].to_i * 100).to_s,
          :currency => "GBP",
          :source => params[:stripe_token],
          :description => "Charge for #{current_user.name}"
      )
      render_success(charge_id: @charge[:id])
    rescue Stripe::CardError => e
      body = e.json_body
      err  = body[:error]
      render_error(422, err[:message])
    rescue Stripe::RateLimitError => e
      body = e.json_body
      err  = body[:error]
      render_error(422, err[:message])
    rescue Stripe::InvalidRequestError => e
      body = e.json_body
      err  = body[:error]
      render_error(422, "Please enter valid #{err[:param]}")
    rescue Stripe::AuthenticationError => e
      body = e.json_body
      err  = body[:error]
      render_error(422, err[:message])
    rescue Stripe::APIConnectionError => e
      body = e.json_body
      err  = body[:error]
      render_error(422, err[:message])
    rescue Stripe::StripeError => e
      body = e.json_body
      err  = body[:error]
      render_error(422, err[:message])
    end
  end

  private

  def get_deal_resource
    @deal = Deal.find(params[:deal_id])
    # @store = @deal.store
  end
end