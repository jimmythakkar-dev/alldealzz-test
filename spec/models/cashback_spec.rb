require 'spec_helper'
require 'factory_girl_rails'
require 'rails_helper'

describe Cashback, type: :model do
  it "has a valid factory" do
  	# FactoryGirl.create(:cashback).should be_valid
  	expect(FactoryGirl.create(:cashback)).to be_valid
	end

	let(:cashback_inst) { FactoryGirl.build(:cashback) }

  it "is invalid without a code" do
  	expect(cashback_inst).to validate_presence_of(:code)
	end

  it "is invalid without  points" do
  	expect(FactoryGirl.build(:cashback, points: nil)).to be_invalid
	end

  it "is invalid without any text" do
  	expect(FactoryGirl.build(:cashback, text: nil)).to be_invalid
	end

  it "is invalid without total_coupons" do
  	expect(FactoryGirl.build(:cashback, total_coupons: nil)).to be_invalid
	end

  it "is invalid without termsandconditions" do
  	expect(FactoryGirl.build(:cashback, termsandconditions: nil)).to be_invalid
	end

  it "is invalid without store_id if its a store cashback" do
  	cashback = FactoryGirl.build(:cashback, store_id: nil)
  	if cashback.cashback_type.to_i.eql?(2)
  		expect(cashback).to be_invalid
		end
	end

	it "is invalid without discount if its a store cashback or deal cashback" do
  	cashback = FactoryGirl.build(:cashback, discount: nil)
  	if ([1,2]).include?(cashback.cashback_type)
  		expect(cashback).to be_invalid
		end
	end

	it { expect(cashback_inst).to validate_uniqueness_of(:code).case_insensitive }

	it { expect(cashback_inst).to belong_to(:store) }

	it { expect(cashback_inst).to have_many(:end_user_points_histories) }

end

describe "scopes" do
  # before(:each) do
	subject {FactoryGirl.create(:cashback, status: true)}
	it ".enabled returns all currently enabled cashbacks" do
		expect(Cashback.enabled.count).to eq(1)
	end
end

describe "callbacks" do
	let(:cashback) { FactoryGirl.create(:cashback) }

	it { expect(cashback).to callback(:set_category_id).after(:create) }
end	
