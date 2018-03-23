class Feed < ActiveRecord::Base
	ValidAt   = { store: 0, online: 1 }
	DealType = { po: 0, ao: 1, bogo: 2, free: 3 }
  FeedType = { image: 0, text: 1, attachment: 2}
  Days = {0 => :sun, 1 => :mon, 2 => :tue, 3 => :wed,
          4 => :thu, 5 => :fri, 6 => :sat}
	belongs_to :store
	belongs_to :deal

  has_many :feed_analytics, dependent: :destroy
  has_many :end_user_feed_favourites, dependent: :destroy
  has_many :favourite_end_users, through: :end_user_feed_favourites

  has_many :end_user_feed_reviews, dependent: :destroy
  has_many :end_user_reviews, through: :end_user_feed_reviews

  has_many :end_user_feed_reminders, dependent: :destroy
  has_many :end_user_reminders, through: :end_user_feed_reminders

  has_many :feed_outlets, dependent: :destroy
  has_many :outlets, through: :feed_outlets

  validates :title, presence: true, length: { maximum: 80 }
  validates :description, length: { maximum: 3000 }

  has_many :feed_detail_images
  
  has_attached_file :photo,
    styles: { :medium => "300x300>", :thumb => "100x100>" },
    default_url: "/images/default/missing.png"

  validates_attachment_content_type :photo,
    :content_type => /^image\/(png|jpeg|jpg)/,
    :message => 'only (png/jpg) images'

  validates_with AttachmentSizeValidator,
    :attributes => [:photo],
    :less_than => 300.kilobytes

  before_save :set_publish_date
  before_save :set_expiry_date

  def valid_at_to_s
    case valid_at
      when ValidAt[:store]
        "store"
      when ValidAt[:online]
        "online"
    end
  end

  def deal_type_to_s
    case deal_type
      when DealType[:po]
        "percent_off"
      when DealType[:ao]
        "amount_off"
      when DealType[:bogo]
        "bye_one_get_one"
      when DealType[:free]
        "free"  
    end
  end

  def feed_type_to_s
    case feed_type
      when FeedType[:image]
        "image_with_text"
      when FeedType[:text]
        "text_only"
      when FeedType[:attachment]
        "attachment"
    end
  end

  def package_days
    return 0 unless expiry_date.present?
    days = (expiry_date.to_date - Time.zone.now.to_date).to_i
    days <= 0 ? 0 : days
  end

  def expired?
    !package_days.nil? && package_days <= 0
  end 

  def toggle_status
    update_attribute(:status, !status)
  end

  def feed_photo
    photo.url if photo.present?
  end

  def share_text_url
    encrypt = self.id + 1350
    s_link = " - #{Settings.api.v1.share_url}/f/#{encrypt}"
    "Find this offer on #{Settings.app_name} | #{title}#{s_link}"
  end

  def days_text
    days.present? ? days.split(',').map {|i| Days[i.to_i].capitalize}.join(', ') : ""
  end

  private

  def set_publish_date
    self.publish_date = Time.zone.now if publish.present?
  end

  def set_expiry_date
    self.publish_date = publish_date || Time.zone.now
    self.expiry_date = if duration.blank?
      # publish_date.end_of_day
      nil
    else
      if (duration.present? and duration != 0)
        (publish_date.beginning_of_day + duration.try(:day)).end_of_day
      end  
    end
  end

  def featured_image_dimensions_validation
    if featured_image.queued_for_write[:original]
      dimensions = Paperclip::Geometry.from_file(featured_image.queued_for_write[:original].path) 
      if dimensions.width > 1024 && dimensions.height > 500
        errors.add(:featured_image,'width and height must be in 1024x500')
      end
    end
  end 
end
