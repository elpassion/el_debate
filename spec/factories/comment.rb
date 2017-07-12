FactoryGirl.define do
  factory :comment do
    debate
    content { FFaker::HipsterIpsum.sentence }
  end
end
