require 'rails_helper'

describe Comment do
  let(:comment) { create(:comment) }
  let(:slack_user) { create(:slack_user) }
  let(:comment_with_user) { create(:comment, :with_user, slack_user: slack_user) }

  it 'returns default values when comment has not user assigned' do
    expect(comment.user_image_url).to eq '/assets/dashboard/default_user.png'
    expect(comment.user_name).to eq 'Anonymous'
  end

  it 'returns slack user values when comment has user assigned' do
    expect(comment_with_user.user_image_url).to eq slack_user.image_url
    expect(comment_with_user.user_name).to eq slack_user.name
  end
end
