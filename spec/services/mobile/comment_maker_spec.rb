require 'rails_helper'

describe Mobile::CommentMaker do

  let(:notifier_mock) do
    double(:notifier, call: nil)
  end

  let(:user) do
    create(:mobile_user)
  end

  let(:params) do
    {
      comment_text: 'I do not agree',
      debate_id: 123,
      username: 'TestUsername',
      user_id: user.id
    }
  end

  subject do
    Mobile::CommentMaker.new(notifier_mock).call(params)
  end

  describe '#call' do
    it 'creates a new comment' do
      expect { subject }.to change(MobileComment, :count).by(1)
    end

    it 'returns a comment with correct assignment to user' do
      comment = subject
      expect(comment).to be_a MobileComment
      expect(comment.user).to eq user
    end

    it 'calls a notification service' do
      expect(notifier_mock).to receive(:call)
      subject
    end
  end
end
