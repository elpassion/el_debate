require 'rails_helper'

describe CommentMaker do
  let(:debate)        { create(:debate) }
  let(:user)          { create(:mobile_user) }
  let(:notifier)      { instance_double(CommentNotifier, call: nil) }
  let(:comment_maker) { described_class.new(debate, user, notifier) }

  describe '#call' do
    let(:params) {{ content: "I  do  not agree \n with this" }}
    subject { comment_maker.call(params) }

    it 'creates a new comment' do
      expect { subject }.to change(Comment, :count).by(1)
    end

    it 'returns a comment' do
      expect(subject).to be_a Comment
    end

    it 'assigns a correct user to a comment' do
      expect(subject.user).to eq user
    end

    it 'saves a correct content' do
      expect(subject.content).to eq 'I do not agree with this'
    end

    it 'calls a notification service' do
      expect(notifier).to receive(:call)
      subject
    end
  end
end