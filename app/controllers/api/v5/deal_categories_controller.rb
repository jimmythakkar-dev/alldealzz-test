class Api::V5::DealCategoriesController < Api::V5::BaseController

  def index
    @normal_categories = DealCategory.root_categories.with_deal_type(0)
    @lmd_categories = DealCategory.root_categories.with_deal_type(1)
    render_success(template: :index)
  end
end
