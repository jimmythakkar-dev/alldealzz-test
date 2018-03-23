class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, 
         :rememberable, :trackable, :validatable

  Roles = {super_admin: 0, stores_admin: 1, sales_admin: 2}
         
  has_one :store
  has_one :mall
  has_many :premium_notification_analytics
  has_many :deal_analytics
  has_many :end_user_points_histories
  validates :username, uniqueness: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
    allow_blank: true

  before_save :save_email_as_username, if: 'username.blank?'

  def save_email_as_username
    self.username = SecureRandom.hex(5)
  end  

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def email_changed?
    false
  end

  def email_required?
    false
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end

  def admin?
    store.blank? && mall.blank?
  end

  def super_admin?
    role == Roles[:super_admin] && admin?
  end

  def stores_admin?
    role == Roles[:stores_admin] && admin?
  end

  def sales_admin?
    role == Roles[:sales_admin] && admin?
  end

  def mall_admin?
    mall.present?
  end 

  def store_admin?
    store.present?
  end

  def manageable
    if mall_admin?
      mall
    else
      nil
    end
  end  

  def user_name
    self.username.present? ? self.username : self.email
  end      
end
