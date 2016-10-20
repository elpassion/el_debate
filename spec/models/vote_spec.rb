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
end
