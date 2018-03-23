class DealCategory < ActiveRecord::Base
  before_update :set_version
  DealType = { deal: 0, last_minute_deal: 1 }
	validates :name, presence: true, length: { maximum: 50 }

  validates :priority_order, :allow_blank => true, uniqueness: { :scope => :deal_type, :message => " has already been taken  " }
  # has_many :deals
  
  has_attached_file :logo_image,
    styles: { :medium => "300x300>", :thumb => "100x100>" },
    default_url: "/images/default/missing.png"
  validates_attachment_content_type :logo_image,
    :content_type => /^image\/(png|jpeg|jpg)/,
    :message => 'only (png/jpg) images'

  has_many :deal_deal_categories, dependent: :destroy
  has_many :deals, through: :deal_deal_categories

  has_many :premium_notifications
  has_many :cashbacks
  has_many :end_user_categories, dependent: :destroy
  has_many :end_users, through: :end_user_categories

  has_many :sub_deal_categories, class_name: self, foreign_key: :sub_deal_category_id
  belongs_to :sub_deal_category, class_name: self, foreign_key: :sub_deal_category_id

  before_save :assign_deal_typeto_root_category
  after_save :update_deal_type_to_child_categories

  scope :sub_categories, -> { where('sub_deal_category_id is not null') }
  scope :root_categories, -> { where('sub_deal_category_id is null').order("priority_order ASC") }
  scope :with_deal_type, -> (type = 0) { where(deal_type: type) }

  scope :deal_sub_categories, -> { with_deal_type.sub_categories }
  scope :deal_root_categories, -> { with_deal_type.root_categories }
  
  scope :last_deal_sub_categories, -> { with_deal_type(1).sub_categories }
  scope :last_deal_root_categories, -> { with_deal_type(1).root_categories }

  def for_deal
    DealCategory::DealType[deal_type]
  end
  def deal_type_to_s
    case deal_type
    when DealType[:deal]
      "deal"
    when DealType[:last_minute_deal]
      "last_minute_deal"
    end
  end
    
  def deal_catgories(*_ids)
    sub_deal_categories.where('id in (?)', _ids).to_a.push(self)
  end

  def category_photo
    logo_image.url if logo_image.present?
  end

  def set_version
    if self.changed?
      category_version = CategoryVersion.first.increment(:version)
      category_version.save
    end
  end
  private

  def assign_deal_typeto_root_category
    self.deal_type = sub_deal_category.deal_type if sub_deal_category  
  end

  def update_deal_type_to_child_categories
    sub_deal_categories.each { |i| i.save }
  end
end
