class Debate < ApplicationRecord
  CODE_LENGTH = 5

  attr_readonly :code

  has_many :answers, dependent: :delete_all
  has_many :auth_tokens, dependent: :delete_all
  has_many :votes, through: :answers

  validates :topic, presence: true

  before_create :set_code
  after_create :create_answers

  def positive_count
    positive_answer.votes_count
  end

  def negative_count
    negative_answer.votes_count
  end

  def neutral_count
    neutral_answer.votes_count
  end

  def positive_answer
    answers.positive.first
  end

  def negative_answer
    answers.negative.first
  end

  def neutral_answer
    answers.neutral.first
  end

  private

  def set_code
    begin
      self.code = generate_code
    end while Debate.exists?(code: self.code)
  end

  def generate_code
    Array.new(CODE_LENGTH) { rand(10) }.join
  end

  def create_answers
    self.answers = Answer.default_answers
  end
end
