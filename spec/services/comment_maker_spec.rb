require 'rails_helper'

describe CommentMaker do
  let(:debate)    { create(:debate) }
  let(:notifier)  { instance_double(CommentNotifier, call: nil) }
  let(:params)    {{ content: "I  do  not agree \n with this" }}

  describe '#call' do
    subject { described_class.new(debate, user, notifier).call(comment_class, params) }

    [[:mobile_user, MobileComment], [:slack_user, SlackComment]].each do |user_type, comment_class|
      context "when making a #{comment_class} comment type" do
        let(:user)          { create(user_type) }
        let(:comment_class) { comment_class }

        it 'creates a new comment' do
          expect { subject }.to change(comment_class, :count).by(1)
        end

        it 'returns a comment' do
          expect(subject).to be_a comment_class
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
  end
end