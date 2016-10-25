class Debate < ApplicationRecord
  CODE_LENGTH = 5

  attr_readonly :code

  has_many :answers, dependent: :delete_all
  has_many :auth_tokens, dependent: :delete_all
  has_many :votes, through: :answers

  validates :topic, presence: true

  before_create :set_code
  after_create :create_answers

  def close!(now = Time.current)
    update!(closed_at: now) unless closed_at?
  end

  def closed?(now = Time.current)
    closed_at? && closed_at.utc <= now.utc
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
