class FeedsController < ApplicationController
  load_and_authorize_resource
  before_filter :load_feeds_resource
  before_filter :load_deals_resource, only: [:new, :edit, :create, :update]

  def index
    @feeds = @feeds
      .order('created_at desc').page(params[:page]).per(2)
  end

  def show
     @feed_detail_images = @feed.feed_detail_images
  end

  def new
    @feed = @feeds.new
    @outlets = @store.outlets if @store.has_outlets?
  end

  def edit
    @outlets = @store.outlets if @store.has_outlets?
  end

  def create
    @feed = @feeds.new(feed_params)

    if @feed.save
      if params[:images]
          params[:images].each { |image|
            @feed.feed_detail_images.create(image: image)
          }
        end
      redirect_to [@store, @feed], notice: 'Feed was successfully created.'
    else
      render :new
    end
  end

  def update
    if @feed.update(feed_params)
      if params[:images]
          params[:images].each { |image|
            @feed.feed_detail_images.create(image: image)
          }
        end
      redirect_to [@store, @feed], notice: 'Feed was successfully updated.'
    else
      render :edit
    end
  end

  # def destroy
  #   @feed.destroy
  #   redirect_to feeds_url, notice: 'Feed was successfully destroyed.'
  # end

  def change_status
    index
    @feed = @feeds.find(params[:feed_id])
    @sucess = @feed.toggle_status if @feed 
  end

  private

    def load_deals_resource
      @deals = @store.deals.enabled_deals
    end  

    def load_feeds_resource
      if @store || params[:store_id].present?
        @store = Store.find(params[:store_id]) if params[:store_id].present?
        @feed = params[:id].present? ? @store.feeds.find(params[:id]) : @store.feeds.new
        authorize! :index, @feed
        @feeds = @store.feeds
      elsif @mall
        @feed = @mall.stores.first.try(:feeds).try(:new)
        authorize! :index, @feed
        @feeds = Feed.by_type(Mall).where('malls.id = ?', @mall.id)
      else
        authorize! :index, Feed
        @feeds = Feed.all
      end
    end

    def feed_params
      params[:feed][:days] = if params[:feed][:days].present? && params[:feed][:days].is_a?(Array)
      if params[:feed][:days].include?("on")
        params[:feed][:days].shift
      end
      params[:feed][:days].join(',')
      else
        params[:feed][:days]
      end
      params[:feed][:outlet_ids] ||= []
      params.require(:feed).permit(:feed_type, :valid_at, :title, :description, :termsandconditions,
        :deal_type, :percent_value, :amount_value, :buy_value, :get_value,
        :total_available, :publish, :publish_date, :duration, :deal_id, :photo, :features, :days, outlet_ids: [], feed_detail_images: [])
    end
end
