require 'rails_helper'

describe Mobile::CommentMaker do
  let(:notifier_mock) { double(:notifier, call: nil) }
  let(:user) { create(:mobile_user) }
  let(:params) do
    {
      comment_text: "I  do  not agree \n with this",
      debate_id: 123,
      user_id: user.id
    }
  end
  subject { described_class.new(notifier_mock).call(params) }

  describe '#call' do
    it 'creates a new comment' do
      expect { subject }.to change(MobileComment, :count).by(1)
    end

    it 'returns a mobile comment' do
      expect(subject).to be_a MobileComment
    end

    it 'assigns a correct user to a comment' do
      expect(subject.user).to eq user
    end

    it 'saves a content without unnecessary whitespaces' do
      expect(subject.content).to eq 'I do not agree with this'
    end

    it 'calls a notification service' do
      expect(notifier_mock).to receive(:call)
      subject
    end
  end
end
