class SalesUserStore < ActiveRecord::Base
  belongs_to :sales_user
  belongs_to :creatable, polymorphic: true

  has_many :sales_user_store_photos

  validates :name, presence: true
  
  has_attached_file :logo,
    styles: { :medium => "300x300>", :thumb => "100x100>" },
    default_url: "/images/default/missing.png"
  validates_attachment_content_type :logo,
    :content_type => /^image\/(png|jpeg|jpg)/,
    :message => 'only (png/jpg) images'
  
  has_attached_file :cover_pic,
    styles: { :medium => "300x300>", :thumb => "100x100>" },
    default_url: "/images/default/missing.png"
  validates_attachment_content_type :cover_pic,
    :content_type => /^image\/(png|jpeg|jpg)/,
    :message => 'only (png/jpg) images'

  def enabled?
    status
  end

  def toggle_status
    update_attribute(:status, !status)
  end

  def is_valid?
    status? && creatable.blank?
  end

  def store_photo
    logo.url if logo.present?
  end

  def address
    if (_address = [address_line_one, address_line_two].join(" ")).present?
      _address
    end  
  end

  def active_status
    if creatable.present?
      "Created"
    elsif status?
      "Ready"    
    else
      "Not ready"
    end  
  end
end
