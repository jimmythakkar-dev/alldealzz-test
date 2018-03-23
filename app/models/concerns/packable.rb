module Packable
  extend ActiveSupport::Concern
  
  def enabled?
    status
  end

  def toggle_status
    update_attribute(:status, !status)
  end  

  def package_days
    return 0 unless expiry_date.present?
    days = (expiry_date.to_date - Time.zone.now.to_date).to_i
    days <= 0 ? 0 : days
  end

  def expired?
    !package_days.nil? && package_days <= 0
  end
end