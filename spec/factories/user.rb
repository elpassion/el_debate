FactoryGirl.define do
  factory :user do
    auth_token
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
  end
end
