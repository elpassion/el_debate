require 'ffaker'
namespace :vote do
  desc 'Vote for specific debate and answer'

  task :positive, [:debate_id, :auth_token] => [:environment] do |_, args|
    debate = Debate.find(args[:debate_id])
    auth_token = args[:auth_token] ? args[:auth_token] : debate.auth_tokens.create!
    v = VoteService.new(answer: debate.answers.positive.first, auth_token: auth_token)
    v.vote!
  end

  task :negative, [:debate_id, :auth_token] => [:environment] do |_, args|
    debate = Debate.find(args[:debate_id])
    auth_token = args[:auth_token] ? args[:auth_token] : debate.auth_tokens.create!
    v = VoteService.new(answer: debate.answers.negative.first, auth_token: auth_token)
    v.vote!
  end

  task :neutral, [:debate_id, :auth_token] => [:environment] do |_, args|
    debate = Debate.find(args[:debate_id])
    auth_token = args[:auth_token] ? args[:auth_token] : debate.auth_tokens.create!
    v = VoteService.new(answer: debate.answers.neutral.first, auth_token: auth_token)
    v.vote!
  end
end
