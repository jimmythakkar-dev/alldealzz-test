module UserIdentifiable
  extend ActiveSupport::Concern

  included do
    validates :password, presence: true
    validate :present_identifier
    validate :uniqueness_identifier

    #-----------
    def self.authenticate(fuser_id, fpassword)
      return if fuser_id.blank? || fuser_id.blank?
      find_by(identifier: fuser_id, password: fpassword, status: true)
    end
    #----------- 
  end
  
  def enabled?
    status
  end

  def toggle_status
    update_attribute(:status, !status)
  end

  private
 
  def present_identifier
    unless identifier.present?
      errors.add(:user_id, "ID can't be blank")
    end  
  end

  def uniqueness_identifier
    if identifier_changed? && self.class.where(identifier: identifier).present?
      errors.add(:user_id, "ID has already been taken")
    end  
  end
end