FactoryGirl.define do
  factory :debate do
    topic { FFaker::HipsterIpsum.sentence }
    closed_at { Time.current + 1.hour }

    factory :closed_debate do
      closed_at { Time.current - 1.hour }
    end
  end
end
