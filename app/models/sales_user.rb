class SalesUser < ActiveRecord::Base
  include UserIdentifiable
  
  has_many :sales_user_stores

  # NOTE  : Same in SalesUser, MerchantUser, EndUser. 
  #         Because used in RailsPushNotifications#resource_owners
  def profile_name
    name.present? ? name : identifier
  end
end
