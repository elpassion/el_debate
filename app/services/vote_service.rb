class VoteService
  def initialize(answer:, auth_token:)
    @answer = answer
    @auth_token = auth_token
  end

  def vote!(notifier = DebateNotifier.new(PusherBroadcaster))
    ActiveRecord::Base.transaction do
      vote_change = VoteChange.new(answer, previous_votes)
      delete_previous_votes
      create_vote!
      debate.reload
      notifier.notify(debate, vote_change)
    end
  end

  private

  attr_reader :auth_token, :answer

  def delete_previous_votes
    previous_votes.destroy_all
  end

  def create_vote!
    @answer.votes.create! auth_token: auth_token
  end

  def debate
    @auth_token.debate
  end

  def previous_votes
    @previous_votes ||= debate.votes.where(auth_token: auth_token)
  end
end
