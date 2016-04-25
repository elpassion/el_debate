class Answer < ApplicationRecord
  ANSWER_TYPES = {
    positive: 1,
    neutral: 2,
    negative: 3
  }
  DEFAULT_VALUES = {
    positive: 'Yes',
    neutral: 'Undecided',
    negative: 'No'
  }

  belongs_to :debate

  validates :answer_type, inclusion: { in: ANSWER_TYPES.values }
  validates :debate_id, :value, presence: true

  def self.default_answers
    ANSWER_TYPES.map do |answer_type, answer_type_id|
      self.new answer_type: answer_type_id, value: DEFAULT_VALUES[answer_type]
    end
  end
end
