class Cashback < ActiveRecord::Base
	CashbackType = { general: 0, deal: 1, store: 2, deal_category: 3}

	belongs_to :deal
	belongs_to :store
	belongs_to :end_user_applied_code
	has_one :transaction_detail
	belongs_to :deal_category
	has_many :end_user_points_histories
	has_attached_file :image,
	styles: { :medium => "300x300>", :thumb => "100x100>" },
	default_url: "/images/default/missing.png"

	validates_attachment_content_type :image,
	:content_type => /^image\/(png|jpeg|jpg)/,
	:message => 'only (png/jpg) images'  

	attr_accessor  :used_coupons
	attr_accessor  :steps
	validates :code, :presence => true, 
            :uniqueness => { :allow_blank => true, :case_sensitive => false }
	validates :text, presence: true
	validates :points, presence: true
	validates :expiry_date, presence: true, if: :validation_condition
	validates :discount, presence: true, if: "cashback_type.eql?(1) || cashback_type.eql?(2)"
	validates :total_coupons, presence: true
	validates :termsandconditions, presence: true
	validates :store_id, presence: true, if: "cashback_type.eql?(2)"
	validates :deal_category_id, presence: true, if: "cashback_type.eql?(3)"
	
	# before_save :set_publish_date
	# before_save :set_expiry_date
	after_create :set_category_id

	scope :enabled, -> { where(status: true) }
	scope :with_unexpired_cashback, -> { where('DATE(cashbacks.expiry_date) >= ? or cashbacks.expiry_date is null', Time.zone.now.utc.to_date) }
	scope :enabled_cashbacks, -> { enabled.with_unexpired_cashback }
	scope :allowed_cashbacks, -> { enabled_cashbacks.where('DATE(cashbacks.publish_date) <= ?', Time.zone.now.utc.to_date) }
	scope :deal_cashbacks, -> {allowed_cashbacks.where(cashback_type: CashbackType[:deal])}
	scope :store_cashbacks, -> {allowed_cashbacks.where(cashback_type: CashbackType[:store])}
	scope :general_cashbacks, -> {allowed_cashbacks.where(cashback_type: CashbackType[:general])}
	scope :trending_cashbacks, -> { where('is_trending is true') }
	scope :deal_store_cashbacks, -> {allowed_cashbacks.where("cashback_type = ? or cashback_type = ?", CashbackType[:deal], CashbackType[:store])}
	scope :cashbacks_listing, -> {allowed_cashbacks.where.not("cashback_type = ? ", CashbackType[:general])}
	scope :deal_category_cashbacks, -> {allowed_cashbacks.where(cashback_type: CashbackType[:deal_category])}
	
	def validation_condition
		if expiry_date.present? && expiry_date < publish_date
			errors.add(:expiry_date, "can't be in the past")
		end
	end

	def allowed?
		Cashback.allowed_cashbacks.include?(self)
	end
	
	def is_cashback_type?(test_type = CashbackType[:general])
		cashback_type == test_type
	end

	def is_cashback_deal?
		is_cashback_type?(CashbackType[:deal])
	end
	
	def is_cashback_store?
		is_cashback_type?(CashbackType[:store])
	end
	
	def is_cashback_deal_category?
		is_cashback_type?(CashbackType[:deal_category])
	end

	def cashback_image
		image.url if image.present?
	end
	
	def cashback_type_to_s
		case cashback_type
		when CashbackType[:general]
			"general"
		when CashbackType[:deal]
			"deal"
		when CashbackType[:store]
			"store"
		when CashbackType[:deal_category]
			"deal category"
		end
	end
	
	def toggle_status
		update_attribute(:status, !status)
	end

	def package_days
		return 0 unless expiry_date.present?
		days = (expiry_date.to_date - Time.zone.now.to_date).to_i
		days <= 0 ? 0 : days
	end

	def used_coupons
		EndUserAppliedCode.where(cashback_id: self.id).count
	end
	
	def check_coupons_count
		if self.used_coupons >= self.total_coupons
			self.update_attributes(status: false)
		else
			self.update_attributes(status: true)
		end
	end

	private

	# def set_publish_date
	# 	self.publish_date = Time.zone.now 
	# end
	# def set_publish_date
	# 	unless @skip_before_save.present?
	# 		self.publish_date = Time.zone.now if publish_date.present?
	# 	end 
	# end
	def set_category_id
		if self.deal_id.present?
			category_id = self.deal.deal_categories.root_categories.first.id
			self.update_attributes(deal_category_id: category_id)
		end
	end

	# def set_expiry_date
	# 	self.publish_date = publish_date || Time.zone.now
	# 	self.expiry_date = if duration.blank?
 #      # publish_date.end_of_day
 #      nil
 #    	else
 #    		if (duration.present? and duration != 0)
 #    		(publish_date.beginning_of_day + duration.try(:day)).end_of_day
 #    		end  
 #    	end
 #  	end
end
