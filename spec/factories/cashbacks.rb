require 'faker'

FactoryGirl.define do
  factory :cashback do |f|
    f.code {Faker::Code.asin}
    f.points {Faker::Number.number}
    f.total_coupons {Faker::Number.number(2)}
    f.text {Faker::App.name}
    f.termsandconditions {Faker::App.name}
    f.store_id {Faker::Number.number(5)}
    f.discount {Faker::Number.number(2)}
    f.cashback_type {Faker::Number.number(1)}
  end
end