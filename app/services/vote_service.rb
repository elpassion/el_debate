class VoteService
  def initialize(answer:, auth_token:)
    @answer = answer
    @auth_token = auth_token
  end

  def vote!(notifier = DebateNotifier.new(PusherBroadcaster))
    ActiveRecord::Base.transaction do
      delete_previous_votes
      create_vote!
      debate.reload
      notifier.notify(debate)
    end
  end

  private

  def delete_previous_votes
    debate.votes.where(auth_token: @auth_token).delete_all
  end

  def create_vote!
    @answer.votes.create! auth_token: @auth_token
  end

  def debate
    @auth_token.debate
  end
end
