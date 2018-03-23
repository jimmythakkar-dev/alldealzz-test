class Outlet < ActiveRecord::Base
  include Distanceable

	belongs_to :store

  has_many :deal_outlets, dependent: :destroy  
  has_many :deals, through: :deal_outlets
  has_many :merchant_users, as: :merchantable, dependent: :destroy


  has_many :feed_outlets, dependent: :destroy
  has_many :feeds, through: :feed_outlets

  has_one :geo_coordinate, as: :locationable
  accepts_nested_attributes_for :geo_coordinate

  geocoded_by :address

  attr_accessor :outlet_steps
  validates :locality, presence: true
  # validates :latitude, presence: true
  # validates :longitude, presence: true

  scope :with_stores, ->  { joins(:store) }
  scope :by_type, lambda { |type| with_stores.joins("LEFT JOIN #{type.table_name} 
    ON ((#{type.table_name}.id = stores.manageable_id AND stores.manageable_type = '#{type.to_s}'))") }
  scope :by_type_allowed, lambda { |type| by_type(type).where("stores.manageable_type is null OR 
    (#{type.table_name}.status is true AND (DATE(#{type.table_name}.expiry_date) >= ? or #{type.table_name}.expiry_date is null))",
    Time.zone.now.utc.to_date) }
  scope :allowed_manageable_stores, -> { by_type_allowed(Mall) }

  scope :enabled, -> { with_stores.where('stores.status = true') }
  scope :with_store_city, -> (city) { with_stores.where('stores.city_id = ?', city.to_i) if city.present? }
  scope :with_unexpired_store, -> { with_stores.where('DATE(stores.expiry_date) >= ? or stores.expiry_date is null', 
    Time.zone.now.utc.to_date) }
  
  scope :allowed_outlets, -> (city = nil) { enabled.with_store_city(city).allowed_manageable_stores.with_unexpired_store }

  scope :outlet_status, -> {where('outlets.status = true')}
  def latitude
    geo_coordinate.try(:latitude)
  end

  def longitude
    geo_coordinate.try(:longitude)
  end

  def local_name
    "#{store.name}, #{locality}"
  end
  def toggle_status
    update_attribute(:status, !status)
  end

  def current_city
    store.current_city
  end

  def share_text_url
    encrypt = self.id + 1350
    s_link = " - #{Settings.api.v1.share_url}/o/#{encrypt}"
    s_name = store.name
    s_address = self.address.present? ? " - #{self.address}" : ''
    "Find this store on #{Settings.app_name} | #{s_name}#{s_address}#{s_link}"
  end
end
