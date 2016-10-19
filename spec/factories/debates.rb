FactoryGirl.define do
  factory :debate do
    topic { Faker::Lorem.sentence }
  end
end
