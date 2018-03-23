class RenameChangeTypeToFlagInDealAnalytics < ActiveRecord::Migration
  def change
    rename_column :deal_analytics, :type, :flag
  end
end
