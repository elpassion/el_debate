class VoteService
  def initialize(answer:, auth_token:)
    @answer = answer
    @auth_token = auth_token
  end

  def vote!(notifier = DebateNotifier.new)
    ActiveRecord::Base.transaction do
      create_or_update_vote!
      debate.reload
      notifier.notify_about_votes(debate)
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
    return @previous_vote if defined?(@previous_vote)
    @previous_vote = debate.votes.find_by(auth_token: auth_token)
  end
end
