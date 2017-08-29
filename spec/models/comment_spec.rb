require 'rails_helper'

describe Comment do
  context 'user params delegation' do
    let(:comment) { create(:comment, user: user) }

    context 'when comment is made by a mobile user' do
      let(:user) { create(:mobile_user) }

      it 'delegates mobile user params' do
        expect(comment.user).to be_a MobileUser
        expect(comment.user_initials_background_color).to eq user.initials_background_color
      end

      it 'is pending' do
        expect(comment.status).to eq('pending')
      end
    end

    context 'when comment is made by a slack user' do
      let(:user) { create(:slack_user) }

      it 'delegates slack user params' do
        expect(comment.user).to be_a SlackUser
      end
    end
  end
end