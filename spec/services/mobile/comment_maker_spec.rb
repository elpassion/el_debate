require 'rails_helper'

describe Mobile::CommentMaker do

  let(:notifier_mock) do
    double(:comment_notifier, call: nil)
  end

  let(:user) do
    create(:mobile_user)
  end

  let(:params) do
    {
        comment_text: 'No agree',
        debate_id: 123,
        auth_token_id: user.auth_token.id
    }
  end

  subject do
    Mobile::CommentMaker.new(notifier_mock)
  end

  describe '#call' do
    it 'creates a new comment' do
      expect {
        subject.call(params)
      }.to change(MobileComment, :count).by(1)
    end

    it 'assigns a comment to a correct user' do
      comment = subject.call(params.merge(user_id: user.id))
      expect(comment.user).to eq user
    end

    it 'executes a CommentNotifier service' do
      expect(notifier_mock).to receive(:call)
      subject.call(params)
    end
  end
end
