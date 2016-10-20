FactoryGirl.define do
  factory :debate do
    topic { FFaker::HipsterIpsum.sentence }
  end
end
