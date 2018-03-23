class AddLogoImageToDealCategory < ActiveRecord::Migration
  def change
  	add_attachment :deal_categories, :logo_image
  end
end
