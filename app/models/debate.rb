class Debate < ApplicationRecord
  include ActionView::Helpers::TextHelper

  CODE_LENGTH = 5

  has_many :answers, dependent: :delete_all
  has_many :auth_tokens, dependent: :delete_all
  has_many :votes, through: :answers

  validates :code, presence: true, length: { is: CODE_LENGTH }, numericality: { only_integer: true }
  validates :topic, presence: true

  before_validation :set_code
  after_create :create_answers

  def positive_count_with_person
    votes_count = answers.where(answer_type: 1).first.votes.count
    pluralize(votes_count, 'person')
  end

  def neutral_count
    answers.where(answer_type: 2).first.votes.count
  end

  def negative_count_with_person
    votes_count = answers.where(answer_type: 3).first.votes.count
    pluralize(votes_count, 'person')
  end

  def positive_percent
    "#{(answers.first.votes.count / votes.count.to_f * 100.0).round}%"
  end

  def negative_percent
    "#{(answers.last.votes.count / votes.count.to_f * 100.0).round}%"
  end

  private

  def set_code
    self.code = generate_code
  end

  def generate_code
    Array.new(CODE_LENGTH) { rand(10) }.join
  end

  def create_answers
    self.answers = Answer.default_answers
  end
end
