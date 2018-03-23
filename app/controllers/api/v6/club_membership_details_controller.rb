class Api::V6::ClubMembershipDetailsController < Api::V6::BaseController
  before_action :end_user_authorize!

  def index
    plan_descriptions = [
        "Get access to the most exclusive deals in the city",
        "Get updates & notifications on the best deals specially curated for you",
        "Become a part of the Exclusive Club now!"
    ]
    plans = ClubMembershipDetail.all.sort.map do |plan|
      {
          id: plan.id,
          name: plan.name,
          price: plan.price
      }
    end
    render_success(plans: plans, descriptions: plan_descriptions)
  end
end
