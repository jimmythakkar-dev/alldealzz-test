namespace :populate_club_exclusive_plans do
  desc "Insert Plans"
  task insert_plans: :environment do
   ["1 Month Pack","3 Months Pack", "6 Months Pack", "One Year Pack"].each do |plan|
      ClubMembershipDetail.find_or_create_by(name: plan, price: 99)
      puts "=> Created: #{plan}"
    end
  end
end