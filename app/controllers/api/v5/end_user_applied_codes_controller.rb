class Api::V5::EndUserAppliedCodesController < Api::V5::BaseController
	before_action :end_user_authorize!
	def index
		end_user_applied_codes = EndUserAppliedCode.all
	end
	def apply_code
		cashback_instance = Cashback.find_by(code: params[:applied_code])
		if cashback_instance.present? && cashback_instance.allowed?
			cashback_id = cashback_instance.id
			code_used_count = EndUserAppliedCode.where(cashback_id: cashback_id).count
			
			if code_used_count <= cashback_instance.total_coupons
				max_time_use_per_user = current_user.end_user_applied_codes.where(cashback_id: cashback_id).count
				if max_time_use_per_user >= cashback_instance.max_time_useable
					render_error(422, "This code has already been used the maximum number of times")
				else
					if params[:deal_code].present?  && cashback_instance.cashback_type.eql?(1).present?
						if cashback_instance.deal_id ==  params[:deal_id].to_i
							message = "Code Applied Successfully"
							if code_points.present?
								message = message + ", You Will Receive #{code_points} Points Cashback After Using This Deal"
							end	
							render_success(message: message, cashback_id: cashback_id, discount: 0)
						else
							render_error(422, "This code is not valid for this deal")
						end
					elsif params[:deal_code].present?  && cashback_instance.cashback_type.eql?(2).present?
						if cashback_instance.store_id ==  params[:store_id].to_i
							message = "Code Applied Successfully"
							if code_points.present?
								message = message + ", You Will Receive #{code_points} Points Cashback After Using This Deal"
							end	
							render_success(message: message, cashback_id: cashback_id, discount: 0)
						else
							render_error(422, "This code is not valid for this deal")
						end
					elsif params[:deal_code].present?  && cashback_instance.cashback_type.eql?(3).present?
						if cashback_instance.deal_category_id ==  params[:category_id].to_i
							message = "Code Applied Successfully"
							if code_points.present?
								message = message + ", You Will Receive #{code_points} Points Cashback After Using This Deal"
							end	
							render_success(message: message, cashback_id: cashback_id, discount: 0)
						else
							render_error(422, "This code is not valid for this deal")
						end
					elsif params[:deal_code].blank?
						if cashback_instance.cashback_type.eql?(0).present?
							save_user_with_code = EndUserAppliedCode.new(end_user_id: current_user.id, cashback_id: cashback_id)
							if save_user_with_code.save
								cashback_instance.check_coupons_count
								end_user_reward_points = EndUserRewardPoint.find_by(end_user_id: current_user.id)
								if end_user_reward_points.present?
									end_user_reward_points.update_attributes(points: end_user_reward_points.points.round(2) + cashback_instance.points.round(2))
									EndUserPointsHistory.create(end_user_id: current_user.id, points: cashback_instance.points.round(2), cashback_id: cashback_instance.id, history_points_type: 0)
								else
									end_user_reward_points = EndUserRewardPoint.create(end_user_id: current_user.id, points: cashback_instance.points.round(2))
									EndUserPointsHistory.create(end_user_id: current_user.id, points: cashback_instance.points.round(2), cashback_id: cashback_instance.id, history_points_type: 0)
								end
								render_success(message: "Code Applied Successfully", points: end_user_reward_points.points, cashback_id: cashback_id)
							else
								render_error(422, "Error occured while applying code, please try again later")
							end
						else
							render_error(422, "This code is not valid here, please use this code while buying the deal")
						end
					else
						render_error(422, "This code is not valid")
					end	
				end
			else
				render_error(422, "This code has been expired")
			end	
		else
			render_error(422, "Please enter a valid code")
		end
	end

	private

	def code_points
		cashback_instance = Cashback.find_by(code: params[:applied_code])
		if params[:deal_code].present? 
			deal = Deal.find_by(id: params[:deal_id].to_i)
			cashback_discount = ((deal.discounted_price.to_f.round(2) * cashback_instance.discount.round(2)) / 100).round(2)
			if cashback_instance.points >= cashback_discount
				points = cashback_discount
			else
				points = cashback_instance.points.round(2)
			end
		end
	end
end
