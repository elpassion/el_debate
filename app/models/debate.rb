class Debate < ApplicationRecord
  has_many :answers, dependent: :delete_all
  has_many :auth_tokens, dependent: :delete_all
  has_many :votes, through: :answers

  validates :code, presence: true, length: { is: 5 }, numericality: { only_integer: true }
  validates :topic, presence: true

  before_validation :set_code
  after_create :create_answers

  private

  def set_code
    self.code = generate_code
  end

  def generate_code
    '99999'
  end

  def create_answers
    self.answers = Answer.default_answers
  end
end
