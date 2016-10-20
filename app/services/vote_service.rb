class VoteService
  def initialize(answer:, auth_token:)
    @answer = answer
    @auth_token = auth_token
  end

  def vote!
    ActiveRecord::Base.transaction do
      delete_previous_votes
      create_vote!
      debate.reload
      PusherBroadcaster.push!(votes_count: debate.votes.count,
                              positive_count: debate.positive_count_with_person,
                              negative_count: debate.negative_count_with_person,
                              neutral_count: debate.neutral_count,
                              positive_percent: debate.positive_percent,
                              negative_percent: debate.negative_percent)
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
