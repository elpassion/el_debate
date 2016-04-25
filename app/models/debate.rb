class Debate < ApplicationRecord
  has_many :answers, dependent: :delete_all

  validates :code, presence: true, length: { is: 5 }, numericality: { only_integer: true }
  validates :topic, presence: true

  before_validation :generate_code
  after_create :create_answers

  private

  def generate_code
    self.code = '99999'
  end

  def create_answers
    self.answers = Answer.default_answers
  end
end
