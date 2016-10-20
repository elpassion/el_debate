class Answer < ApplicationRecord
  DEFAULT_VALUES = {
    positive: 'Yes',
    neutral: 'Undecided',
    negative: 'No'
  }

  enum answer_type: %i(positive neutral negative)

  belongs_to :debate, required: true
  has_many :votes, dependent: :delete_all

  validates :value, presence: true

  def self.default_answers
    DEFAULT_VALUES.map do |answer_type, answer_value|
      new answer_type: answer_type, value: answer_value
    end
  end

  def self.positive_value
    positive.first.value
  end

  def self.neutral_value
    neutral.first.value
  end

  def self.negative_value
    negative.first.value
  end

  def answer_type_key
    answer_type.to_sym
  end
end
