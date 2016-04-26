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
  has_many :votes, dependent: :delete_all

  validates :answer_type, inclusion: { in: ANSWER_TYPES.values }
  validates :debate_id, :value, presence: true

  def self.default_answers
    ANSWER_TYPES.map do |answer_type_key, answer_type_id|
      self.new answer_type: answer_type_id, value: DEFAULT_VALUES[answer_type_key]
    end
  end

  def answer_type_key
    ANSWER_TYPES.key answer_type
  end
end
