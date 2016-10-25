namespace :debate do
  desc 'Generate auth token for specific debate'
  task :auth_token, [:debate_id] => [:environment] do |_, args|
    auth_token = Debate.find(args[:debate_id]).auth_tokens.create!
    puts auth_token.value
  end

  desc 'Vote for positive answer for specific debate and auth_token'
  task :positive_vote, [:debate_id, :auth_token] => [:environment] do |_, args|
    debate = Debate.find(args[:debate_id])
    auth_token = find_or_create_auth_token(debate, args[:auth_token])
    vote(debate.answers.positive.first, auth_token)
  end

  desc 'Vote for negative answer for specific debate and auth_token'
  task :negative_vote, [:debate_id, :auth_token] => [:environment] do |_, args|
    debate = Debate.find(args[:debate_id])
    auth_token = find_or_create_auth_token(debate, args[:auth_token])
    vote(debate.answers.negative.first, auth_token)
  end

  desc 'Vote for neutral answer for specific debate and auth_token'
  task :neutral_vote, [:debate_id, :auth_token] => [:environment] do |_, args|
    debate = Debate.find(args[:debate_id])
    auth_token = find_or_create_auth_token(debate, args[:auth_token])
    vote(debate.answers.neutral.first, auth_token)
  end

  private

  def find_or_create_auth_token(debate, auth_token)
    auth_token ? AuthToken.find_by_value(args[:auth_token]) : debate.auth_tokens.create!
  end

  def vote(answer, auth_token)
    v = VoteService.new(answer: answer, auth_token: auth_token)
    v.vote!
  end
end
