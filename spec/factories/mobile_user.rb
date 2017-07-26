FactoryGirl.define do
  factory :mobile_user do
    sequence(:first_name) { |n| "Foooo#{n}" }
    sequence(:last_name) { |n| "Foooo#{n}" }
    auth_token
  end
end
