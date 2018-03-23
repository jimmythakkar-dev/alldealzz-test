namespace :create_users do
  desc "To create super admin user"
  task super_admin: :environment do
  	if User.where(role: User::Roles[:super_admin]).blank? && 
  		new_user(:super_admin).save
	  	puts "=> Super Admin Created: super_admin/password"
	  end	
  end

  desc "To create stores admin user"
  task stores_admin: :environment do
  	if User.where(role: User::Roles[:stores_admin]).blank? && 
  		new_user(:stores_admin).save
	  	puts "=> Stores Admin Created: stores_admin/password"
  	end
  end

  desc "To create sales admin user"
  task sales_admin: :environment do
  	if User.where(role: User::Roles[:sales_admin]).blank? && 
        new_user(:sales_admin).save
	  	puts "=> Sales Admin Created: sales_admin/password"
		end  
  end

  task :all => [:super_admin, :sales_admin, :stores_admin]

  def new_user(type)
  	User.new(email: 'admin@example.com', 
		  	password: 'password', 
		  	password_confirmation: 'password',
		  	username: type,
		  	role: User::Roles[type])
  end

end
