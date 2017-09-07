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
  validates :code, presence: true, uniqueness: true,
                   length: { is: CODE_LENGTH }, numericality: { only_integer: true }

  before_save  :block_code_change

  mattr_accessor :debate_notifier
  self.debate_notifier = DebateNotifier.new

  scope :opened_debates, -> { where(closed: false) }
  scope :closed_debates, -> { where(closed: true) }

  def open
    update(closed: false)
  end

  def close
    update(closed: true)
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
    @positive_answer ||= answers.positive.take
  end

  def negative_answer
    @negative_answer ||= answers.negative.take
  end

  def neutral_answer
    @neutral_answer ||= answers.neutral.take
  end

  def retrieve_comments
    moderate? ? comments.accepted : comments
  end

  def create_auth_token!
    auth_tokens.create!
  end

  def last_comments(count: 5)
    comments
      .accepted
      .order(created_at: :desc)
      .first(count)
  end

  private

  def block_code_change
    if code_changed? && code_was.present?
      self.code = code_was
    end
  end
end
