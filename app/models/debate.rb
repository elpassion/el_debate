class Debate < ApplicationRecord
  CODE_LENGTH = 5

  attr_readonly :code

  has_many :answers, dependent: :delete_all
  has_many :auth_tokens, dependent: :delete_all
  has_many :votes, through: :answers

  validates :topic, presence: true

  before_create :set_code
  after_create :create_answers

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
