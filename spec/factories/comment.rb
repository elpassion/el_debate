FactoryGirl.define do
  factory :comment do
    debate
    user
    content { FFaker::HipsterIpsum.sentence }
  end
end
