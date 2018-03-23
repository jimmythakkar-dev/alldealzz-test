class CreateCategoryVersions < ActiveRecord::Migration
  def change
    create_table :category_versions do |t|
    	t.integer :version, default: 1
      t.timestamps null: false
    end
  end
end
