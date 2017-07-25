require 'rails_helper'

describe Comment do
  context 'user params delegation' do
    let(:comment) { create(:comment, user: user) }

    context 'when comment is made by a mobile user' do
      let(:user) { create(:mobile_user) }

      it 'delegates mobile user params' do
        expect(comment.user).to be_a MobileUser
        expect(comment.user_avatar_color).to eq user.avatar_color
        expect(comment.user_name).to eq user.name
      end
    end

    context 'when comment is made by a slack user' do
      let(:user) { create(:slack_user) }

      it 'delegates slack user params' do
        expect(comment.user).to be_a SlackUser
        expect(comment.user_image_url).to eq user.image_url
        expect(comment.user_name).to eq user.name
      end
    end
  end
end