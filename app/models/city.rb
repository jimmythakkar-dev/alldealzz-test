class City < ActiveRecord::Base
  has_many :stores
  has_many :end_users
  has_many :malls
  has_many :requested_notifications
  has_many :end_user_subscribed_cities, dependent: :destroy


  def self.subscribe_to_mailchimp(current_user)
    city_id = City.first.id
    list_id = "204918d03a"
    user_email = current_user.email
    if user_email.present?
      gibbon = Gibbon::Request.new(symbolize_keys: true)
      email_hash = Digest::MD5.hexdigest(user_email)
      member = gibbon.lists(list_id).members(email_hash).retrieve rescue false
      if member.present?
        if member[:status] == "subscribed" && EndUserSubscribedCity.find_by(end_user_id: current_user.id, city_id: city_id).blank?
          gibbon.lists(list_id).members(email_hash).update(body: { status: "unsubscribed" })
        elsif EndUserSubscribedCity.find_by(end_user_id: current_user.id, city_id: city_id).present? && member[:status] != "subscribed"
          gibbon.lists(list_id).members(email_hash).update(body: { status: "subscribed" })
        end
      else
        first_name = current_user.name.present? ? current_user.name : ""
        gibbon.lists(list_id).members.create(body: {email_address: user_email, status: "subscribed", merge_fields: {FNAME: first_name}}) if EndUserSubscribedCity.find_by(end_user_id: current_user.id, city_id: city_id).present?
      end
    end
  end
end
