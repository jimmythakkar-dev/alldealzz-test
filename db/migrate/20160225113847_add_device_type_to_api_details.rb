class AddDeviceTypeToApiDetails < ActiveRecord::Migration
  def change
    add_column :api_details, :device_type, :boolean
  end
end
