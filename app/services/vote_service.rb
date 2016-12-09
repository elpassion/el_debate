class VoteService
  def initialize(answer:, auth_token:)
    @answer = answer
    @auth_token = auth_token
    @change_hash = { positive: 0, negative: 0 }
  end

  def vote!(notifier = DebateNotifier.new(PusherBroadcaster))
    ActiveRecord::Base.transaction do
      delete_previous_votes
      create_vote!
      debate.reload
      notifier.notify(debate, @change_hash)
    end
  end

  private

  def delete_previous_votes
    old_votes = debate.votes.where(auth_token: @auth_token)
    add_collection_to_change_hash(old_votes)
    old_votes.destroy_all
  end

  def create_vote!
    @answer.votes.create! auth_token: @auth_token
    add_to_change_hash(@answer, 1)
  end

  def add_collection_to_change_hash(old_votes)
    old_votes.each do |vote|
      add_to_change_hash(vote.answer, -1)
    end
  end

  def add_to_change_hash(answer, counter)
    if answer.positive?
      @change_hash[:positive] += counter
    elsif answer.negative?
      @change_hash[:negative] += counter
    end
  end

  def debate
    @auth_token.debate
  end
end
