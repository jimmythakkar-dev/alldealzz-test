namespace :create_cat_version do
	desc "Create cat_version"
	task cat_version: :environment do
		cat_version = CategoryVersion.find_or_create_by(version: 1)
		puts "=> Created version: #{cat_version.version}"
	end
end