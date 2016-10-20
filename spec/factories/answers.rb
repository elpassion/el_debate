FactoryGirl.define do
  factory :answer do
    value { Faker::Lorem.word }
    debate
    answer_type { Answer::ANSWER_TYPES.values.sample }

    factory :positive_answer do
      answer_type Answer::ANSWER_TYPES[:positive]
    end

    factory :neutral_answer do
      answer_type Answer::ANSWER_TYPES[:neutral]
    end

    factory :negative_answer do
      answer_type Answer::ANSWER_TYPES[:negative]
    end
  end
end
