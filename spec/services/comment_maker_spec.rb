require 'rails_helper'

describe CommentMaker do

  let(:notifier_mock) do
    double(:comment_notifier, call: nil)
  end

  let(:params) do
    {
        comment_text: "No agree",
        debate_id: 123
    }
  end

  let(:user) do
    create(:slack_user)
  end

  subject do
    CommentMaker.new(notifier_mock)
  end

  describe "#call" do
    it "creates a new comment" do
      expect {
        subject.call(params)
      }.to change(Comment, :count).by(1)
    end

    it "assigns a comment to a correct user if given" do
      comment = subject.call(params.merge(user_id: user.id))
      expect(comment.slack_user).to eq user
    end

    it "returns anonymous user if user_id is not given" do
      comment = subject.call(params)
      expect(comment.user_name).to eq 'Anonymous'
    end

    it "executes a CommentNotifier service" do
      expect(notifier_mock).to receive(:call)
      subject.call(params)
    end
  end
end
