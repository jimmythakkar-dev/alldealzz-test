class AddMessageToApiDetails < ActiveRecord::Migration
  def change
    add_column :api_details, :message, :text
  end
end
