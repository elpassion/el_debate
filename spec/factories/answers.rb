FactoryGirl.define do
  factory :answer do
    value { FFaker::HipsterIpsum.word }
    debate
    answer_type { Answer.answer_types.keys.sample }

    factory :positive_answer do
      answer_type :positive
    end

    factory :neutral_answer do
      answer_type :neutral
    end

    factory :negative_answer do
      answer_type :negative
    end
  end
end
