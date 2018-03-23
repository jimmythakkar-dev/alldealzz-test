class CreateApiDetails < ActiveRecord::Migration
  def change
    create_table :api_details do |t|
    	t.string :api_version, null: false
    	t.string :app_version
    	t.string :app_type
    	t.text :faq
    	t.text :about_us

      t.timestamps null: false
    end
  end
end
