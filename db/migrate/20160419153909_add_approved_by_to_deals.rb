class AddApprovedByToDeals < ActiveRecord::Migration
  def up
    add_column :deals, :approved_by, :integer
    add_index :deals, :approved_by

		user = User.find_by(role: User::Roles[:super_admin])
		if user.present?
	    Deal.find_in_batches(batch_size: 100).with_index do |group, batch|
			  puts "Processing group ##{batch} : Adding approver"
				group.each { |deal| deal.update_attribute(:approver, user) }
				sleep(10)
			end
		end  
  end

  def down
    remove_index :deals, :approved_by
  	remove_column :deals, :approved_by
  end
end
