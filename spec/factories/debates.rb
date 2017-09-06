FactoryGirl.define do
  factory :debate do
    transient do
      comments_status :pending
    end

    topic { FFaker::HipsterIpsum.sentence }

    trait :closed_debate do
      closed true
    end

    trait :with_comments do
      after(:create) do |debate, evaluator|
        3.times do
          create(:comment, debate: debate, status: evaluator.comments_status)
        end
      end
    end

    initialize_with { DebateMaker.call(attributes) }
  end
end
