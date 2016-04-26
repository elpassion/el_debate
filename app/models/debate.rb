class Debate < ApplicationRecord
  CODE_LENGTH = 5

  has_many :answers, dependent: :delete_all
  has_many :auth_tokens, dependent: :delete_all
  has_many :votes, through: :answers

  validates :code, presence: true, length: { is: CODE_LENGTH }, numericality: { only_integer: true }
  validates :topic, presence: true

  before_validation :set_code
  after_create :create_answers

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
