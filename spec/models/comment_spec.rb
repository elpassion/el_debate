require 'rails_helper'

describe Comment do
  let(:slack_user) { create(:slack_user) }
  let(:mobile_user) { create(:mobile_user) }
  let(:slack_comment) { create(:slack_comment, user: slack_user) }
  let(:mobile_comment) { create(:mobile_comment, user: mobile_user) }

  it 'returns slack user proper values' do
    expect(slack_comment.user_image_url).to eq slack_user.image_url
    expect(slack_comment.user_name).to eq slack_user.name
  end

  it 'returns mobile user proper values' do
    expect(mobile_comment.user_image_url).to eq mobile_user.image_url
    expect(mobile_comment.user_name).to eq mobile_user.name
  end
end
