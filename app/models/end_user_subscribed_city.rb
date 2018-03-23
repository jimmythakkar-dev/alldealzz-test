class EndUserSubscribedCity < ActiveRecord::Base
  belongs_to :end_user
  belongs_to :city
end
