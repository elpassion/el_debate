FactoryGirl.define do
  factory :answer do
    value { FFaker::HipsterIpsum.word }
    debate
    answer_type { Answer.answer_types.keys.sample }

    trait :positive_answer do
      answer_type :positive
    end

    trait :neutral_answer do
      answer_type :neutral
    end

    trait :negative_answer do
      answer_type :negative
    end

    factory :closed_debate_answer do
      association :debate, factory: :closed_debate
    end
  end
end
