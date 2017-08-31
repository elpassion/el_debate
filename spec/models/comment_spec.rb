require 'rails_helper'

describe Comment do
  context 'user params delegation' do
    let(:comment) { create(:comment, user: user) }

    context 'when comment is made by a user' do
      let(:user) { create(:user) }

      it 'delegates user params' do
        expect(comment.user).to be_a User
        expect(comment.user_initials_background_color).to eq user.initials_background_color
      end

      it 'is pending' do
        expect(comment.status).to eq('pending')
      end
    end
  end
end