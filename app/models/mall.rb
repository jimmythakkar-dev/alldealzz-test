class Mall < ActiveRecord::Base
  include Distanceable
  include Packable

	default_scope { order('malls.created_at DESC') }

  geocoded_by :address

	validates :name, presence: true, length: { maximum: 50 }
  
  belongs_to :user
  belongs_to :current_city, class_name: "City", foreign_key: "city_id"
  has_many :stores, as: :manageable, dependent: :destroy

  has_many :end_user_follow_malls, dependent: :destroy
  has_many :follow_end_users, through: :end_user_follow_malls

  accepts_nested_attributes_for :user

  has_attached_file :logo,
    styles: { :medium => "300x300>", :thumb => "100x100>" },
    default_url: "/images/default/missing.png"
  validates_attachment_content_type :logo,
    :content_type => /^image\/(png|jpeg|jpg)/,
    :message => 'only (png/jpg) images'
  validates_with AttachmentSizeValidator, 
    :attributes => :logo, 
    :less_than => 50.kilobytes
  validate :logo_dimensions_validation
    

  before_create :set_expiry_date
  before_save :set_expiry_date

  scope :enabled, -> { where(status: true) }
  scope :city_malls, -> (city) { where(arel_table[:city_id].eq city.to_i) if city.present? }
  scope :allowed_malls, -> (city = nil) { enabled.city_malls(city).where('DATE(malls.expiry_date) >= ? or malls.expiry_date is null', Time.zone.now.utc.to_date) }

  # TODO
  scope :have_store_quota, -> { where('') }

  def allowed?
    Mall.allowed_malls.include?(self)
  end	

  def no_of_stores
    stores.allowed_stores.to_a.count
  end

  def mall_logo
    logo.url if logo.present?
  end	

  private 

  def set_expiry_date
    if self.created_at.present?
      self.expiry_date = (duration.present? and duration != 0) ? (self.created_at + duration.try(:day)) : nil
    end 
  end

  def logo_dimensions_validation
    if logo.queued_for_write[:original]
      dimensions = Paperclip::Geometry.from_file(logo.queued_for_write[:original].path) 
      if dimensions.width > 200 && dimensions.height > 200
        errors.add(:logo,'width and height must be in 200x200')
      end
    end  
  end
end
