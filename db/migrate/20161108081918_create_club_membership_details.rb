class CreateClubMembershipDetails < ActiveRecord::Migration
  def change
    create_table :club_membership_details do |t|
      t.string :name
      t.integer :price
      t.string :description

      t.timestamps null: false
    end
  end
end
