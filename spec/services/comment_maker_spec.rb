require 'rails_helper'

describe CommentMaker do
  let(:user) { create(:user) }
  let(:notifier) { instance_double(CommentNotifier, comment_added: nil) }
  let(:comment_maker) { described_class.new(debate, user, notifier) }
  let(:params) { { content: "I  do  not agree \n with this" } }
  subject { comment_maker.call(params) }

  describe '#call' do
    context 'when debate is moderable' do
      let(:debate) { create(:debate) }

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

      it 'saves a correct status' do
        expect(subject.status).to eq('pending')
      end

      it 'calls a notification service' do
        expect(notifier).to receive(:comment_added)
        subject
      end
    end

    context 'when debate is non moderable' do
      let(:debate) { create(:debate, moderate: false) }

      it 'sets comment status to active' do
        expect(subject.status).to eq('accepted')
      end
    end
  end
end