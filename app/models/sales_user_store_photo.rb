class SalesUserStorePhoto < ActiveRecord::Base
  belongs_to :end_user_store


	has_attached_file :photo,
    styles: { :medium => "300x300>", :thumb => "100x100>" },
    default_url: "/images/default/missing.png"

  validates_attachment_presence :photo  
  validates_attachment_content_type :photo,
    :content_type => /^image\/(png|jpeg|jpg)/,
    :message => 'only (png/jpg) images'


  def store_photo
    photo.url if photo.present?
  end  
end
