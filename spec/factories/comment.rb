FactoryGirl.define do
  factory :comment do
    debate
    content { FFaker::HipsterIpsum.sentence }

    trait :with_user do
      slack_user
    end
  end
end
