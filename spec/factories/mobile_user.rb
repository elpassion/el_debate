FactoryGirl.define do
  factory :mobile_user do
    auth_token
    trait :with_first_name_and_last_name do
      sequence(:first_name) { |n| "First Name#{n}" }
      sequence(:last_name) { |n| "Last Name#{n}" }
    end
  end
end
