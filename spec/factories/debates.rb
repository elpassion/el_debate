FactoryGirl.define do
  factory :debate do
    topic { FFaker::HipsterIpsum.sentence }

    trait :closed_debate do
      closed true
    end

    trait :with_comments do
      after(:create) do |debate|
        3.times do
          create(:comment, debate: debate)
        end
      end
    end

    initialize_with { DebateMaker.call(attributes) }
  end
end
