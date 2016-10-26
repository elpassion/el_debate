namespace :debate do
  desc 'Generate auth token for specific debate'
  task :auth_token, [:debate_id] => [:environment] do |_, args|
    puts Voter.new(args).auth_token.value
  end

  desc 'Vote for positive answer for specific debate and auth_token'
  task :positive_vote, [:debate_id, :auth_token] => [:environment] do |_, args|
    Voter.new(args).vote(:positive)
  end

  desc 'Vote for negative answer for specific debate and auth_token'
  task :negative_vote, [:debate_id, :auth_token] => [:environment] do |_, args|
    Voter.new(args).vote(:negative)
  end

  desc 'Vote for neutral answer for specific debate and auth_token'
  task :neutral_vote, [:debate_id, :auth_token] => [:environment] do |_, args|
    Voter.new(args).vote(:neutral)
  end
end

class Voter
  attr_reader :auth_token

  def initialize(debate_id:, auth_token: nil)
    @debate = Debate.find(debate_id)
    @auth_token = find_or_create_auth_token(auth_token)
  end

  def vote(answer_type)
    VoteService.new(answer: answer(answer_type), auth_token: auth_token).vote!
  end

  private

  attr_reader :debate

  def find_or_create_auth_token(auth_token)
    if auth_token.blank?
      debate.auth_tokens.create!
    else
      AuthToken.find_by_value(auth_token)
    end
  end

  def answer(answer_type)
    debate.answers.send(answer_type).first
  end
end
