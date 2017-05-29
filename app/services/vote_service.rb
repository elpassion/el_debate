class VoteService
  def initialize(answer:, auth_token:)
    @answer = answer
    @auth_token = auth_token
  end

  def vote!(notifier = DebateNotifier.new(PusherBroadcaster))
    ActiveRecord::Base.transaction do
      vote_change = VoteChange.new(answer, previous_vote)
      create_or_update_vote!
      debate.reload
      notifier.notify(debate, vote_change)
    end
  end

  private

  attr_reader :auth_token, :answer

  def create_or_update_vote!
    if previous_vote
      previous_vote.update! answer_id: answer.id
    else
      answer.votes.create! auth_token: auth_token
    end
  end

  def debate
    @auth_token.debate
  end

  def previous_vote
    @previous_vote ||= debate.votes.find_by(auth_token: auth_token)
  end
end
