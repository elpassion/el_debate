class Vote < ApplicationRecord
  belongs_to :answer, required: true, counter_cache: true
  belongs_to :auth_token, required: true

  delegate :debate, to: :answer, allow_nil: true

  validate :debate_is_not_closed

  private

  def debate_is_not_closed
    errors[:base] << 'Debate is closed' if debate_closed?
  end

  def debate_closed?
    debate && debate.closed?
  end
end
