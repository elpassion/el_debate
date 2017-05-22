require 'rails_helper'

describe CommentSerializer do
  let(:comment) { create(:comment) }
  let(:slack_user) { create(:slack_user)}
  let(:comment_with_user) do
    Slack::Comment.create!(
        slack_user_id: slack_user.id,
        content: FFaker::HipsterIpsum.sentence,
        debate_id: create(:debate)
    )
  end

  it 'returns default values when comment has not user assigned' do
    expect(serialized_comment[:user_image_url]).to eq '/assets/dashboard/default_user.png'
    expect(serialized_comment[:user_name]).to eq 'Anonymous'
  end

  it 'returns slack user values when comment has user assigned' do
    expect(serialized_user_comment[:user_image_url]).to eq slack_user.image_url
    expect(serialized_user_comment[:user_name]).to eq slack_user.name
  end

  def serialized_comment
    described_class.new(comment).to_h
  end

  def serialized_user_comment
    described_class.new(comment_with_user).to_h
  end
end
