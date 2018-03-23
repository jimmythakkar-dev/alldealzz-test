class TransactionDetail < ActiveRecord::Base

	PaymentStatus = {pending: 0, success: 1, failed: 2}
	SettlementStatus = {pending: 0, success: 1, failed: 2}

	serialize :product_info, Hash

	has_one :end_user_used_deal
	has_one :deal, through: :end_user_used_deal
	has_one :end_user, through: :end_user_used_deal
	belongs_to :end_user_applied_code
	belongs_to :cashback
	belongs_to :end_user_points_history

	scope :successfull_settlement, ->  { where(settlement_status: TransactionDetail::SettlementStatus[:success]) }
	scope :pending_settlement, ->  { where(settlement_status: TransactionDetail::SettlementStatus[:pending]) }
	scope :failed_settlement, ->  { where(settlement_status: TransactionDetail::SettlementStatus[:failed]) }
	scope :settled, -> { successfull_settlement }
	scope :unsettled, -> { where.not(settlement_status: TransactionDetail::SettlementStatus[:success]) }

	scope :successful_payment, ->  { where(payment_status: TransactionDetail::PaymentStatus[:success]) }
	scope :failed_payment, ->  { where(payment_status: TransactionDetail::PaymentStatus[:failed]) }

	scope :no_full_commission_deals, ->  { joins(:deal).where("deals.commission_percent != ?", 100) }
	scope :used_only_deals, -> {joins(:end_user_used_deal).where("end_user_used_deals.used_status is true")}
	
	validate :has_bank_ref_id_on_settlement
	validate :already_settled
	
	def get_email
		deal.store.user
	end
	
	def cashback_settlement(user_id, deal_id)
		if cashback_id.present?
			end_user_applied_code = EndUserAppliedCode.create(end_user_id: user_id, cashback_id: cashback_id)
			 
			self.update_attributes(end_user_applied_code_id: end_user_applied_code.id)
			 cashback_check= Cashback.find_by(id: cashback_id)
			 cashback_check.check_coupons_count
		end
		if points.present? && points > 0.00
			end_user_reward_points = EndUserRewardPoint.find_by(end_user_id: user_id)
			end_user_reward_points.update(points: end_user_reward_points.points.round(2) - points.round(2))
			end_user_points_history = EndUserPointsHistory.create(end_user_id: user_id, points: points.round(2), deal_id: deal_id, history_points_type: 1)
			self.update_attributes(end_user_points_history_id: end_user_points_history.id)
		end	
	end
	
	def cashback_refund_pending_settlement(user_id)
		if self.end_user_applied_code_id.present?
			end_user_applied_code_id = self.end_user_applied_code_id 
			end_user_applied_code = EndUserAppliedCode.find_by(id: end_user_applied_code_id)
			if end_user_applied_code.present? 
				end_user_applied_code.destroy
			end
		end
		if self.points.present?
			end_user_reward_points = EndUserRewardPoint.find_by(end_user_id: user_id)
			if end_user_reward_points.present?
				end_user_reward_points.update_attributes(points: end_user_reward_points.points.round(2) + self.points.round(2))
				end_user_points_history = EndUserPointsHistory.find_by(id: end_user_points_history_id)
				if end_user_points_history.present?
					end_user_points_history.update_attributes(points_status: false, history_points_type: 3)
				end
			end
		end
		self.update_attributes(payment_status: 2)
	end
	
	def percentage_off
		cashback_value = Cashback.find(self.cashback_id)
		cashback_discount = ((self.deal.discounted_price.to_f.round(2) * cashback_value.discount.round(2)) / 100).round(2)
	end
	
	private

	def has_bank_ref_id_on_settlement
		if settlement_status == TransactionDetail::SettlementStatus[:success] && bank_ref_id.blank?
			errors.add(:bank_ref_id, 'should be present')
		end	
	end

	def already_settled
		if !settlement_status_changed? && settlement_status == TransactionDetail::SettlementStatus[:success]
			errors.add(:settlement_status, 'already settled, cannot edit')
		end	
	end
end
