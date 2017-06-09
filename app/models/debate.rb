require 'code_generator'

class Debate < ApplicationRecord
  CODE_LENGTH = 5
  CODE_CHARSET = ('0'..'9')

  has_many :answers, dependent: :delete_all
  has_many :auth_tokens, dependent: :delete_all
  has_many :votes, through: :answers
  has_many :comments

  accepts_nested_attributes_for :answers
  validates :topic, presence: true
  validates :closed_at, presence: true
  validates :code, presence: true, uniqueness: true,
                   length: { is: CODE_LENGTH }, numericality: { only_integer: true }

  before_save  :block_code_change

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

  private

  def block_code_change
    if code_changed? && code_was.present?
      self.code = code_was
    end
  end
end
