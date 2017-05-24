require 'code_generator'

class Debate < ApplicationRecord
  CODE_LENGTH = 5
  CODE_GENERATION_MAX_RETRIES = 5
  CODE_CHARSET = ('0'..'9')

  mattr_accessor :debate_code_generator
  self.debate_code_generator = CodeGenerator.new(CODE_CHARSET, CODE_LENGTH)

  has_many :answers, dependent: :delete_all
  has_many :auth_tokens, dependent: :delete_all
  has_many :votes, through: :answers
  has_many :comments

  accepts_nested_attributes_for :answers
  validates :topic, presence: true
  validates :closed_at, presence: true

  before_save  :block_code_change
  after_create :generate_code
  after_create :create_answers

  attribute :closed_at, :datetime, default: -> { Time.current + 1.hour }

  def self.opened_for_channel!(channel_name)
    where(
      "channel_name = ? AND closed_at > ?",
       channel_name, Time.current
    ).first!
  end

  def closed?(now = Time.current)
    closed_at? && closed_at.utc <= now.utc
  end

  def votes_count
    votes.count
  end

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

  def generate_code
    debate_code_generator.generate(num_retries: CODE_GENERATION_MAX_RETRIES) do |code|
      begin
        update!(code: code)
      rescue ActiveRecord::RecordNotUnique
        false
      end
    end
  rescue debate_code_generator.num_retries_error
    # noop
  end

  private

  def block_code_change
    if code_changed? && code_was.present?
      self.code = code_was
    end
  end

  def create_answers
    self.answers = Answer.default_answers
  end
end
