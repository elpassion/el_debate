FactoryGirl.define do
  factory :debate do
    topic { FFaker::HipsterIpsum.sentence }

    trait :closed_debate do
      closed true
    end

    initialize_with { DebateMaker.call(attributes) }
  end
end
