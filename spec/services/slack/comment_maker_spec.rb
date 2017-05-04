require 'rails_helper'

describe Slack::CommentMaker do
  let(:notifier_mock) do
    double(:comment_notifier, call: nil)
  end

  subject do
    Slack::CommentMaker.new(notifier_mock)
  end

  let(:user) do
    create(:slack_user)
  end

  let(:params) do
    {
      user_id: user.id,
      comment_text: "No agree",
      debate_id: 123
    }
  end

  describe "#call" do
    it "creates a new comment" do
      expect {
        subject.call(params)
      }.to change(Slack::Comment, :count).by(1)
    end

    it "assigns a comment to a correct user" do
      comment = subject.call(params)
      expect(comment.slack_user).to eq user
    end

    it "executes a CommentNotifier service" do
      expect(notifier_mock).to receive(:call)
      subject.call(params)
    end
  end
end
