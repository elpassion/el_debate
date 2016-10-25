require 'rails_helper'

describe Vote, type: :model do
  it 'validates answer presence' do
    vote = build(:vote, answer: nil)
    expect(vote).not_to be_valid
    expect(vote.errors[:answer]).to include('must exist')
  end

  it 'validates auth_token presence' do
    vote = build(:vote, auth_token: nil)
    expect(vote).not_to be_valid
    expect(vote.errors[:auth_token]).to include('must exist')
  end

  it 'is invalid when debate is closed' do
    vote = build(:vote, answer: create(:closed_debate_answer))
    expect(vote).not_to be_valid
    expect(vote.errors[:base]).to include('Debate is closed')
  end
end
