FactoryGirl.define do
  factory :mobile_user do
    sequence(:name) { |n| "Foooo#{n}" }
    auth_token
  end
end
