require 'rails_helper'

describe Slack::CommentMaker do
  let(:model) { Slack::Comment }

  let(:notifier_mock) do
    double(:comment_notifier, call: nil)
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

  subject do
    Slack::CommentMaker.new(notifier_mock)
  end

  it_behaves_like "abstract comment maker"

  it "assigns a comment to a correct user" do
    comment = subject.call(params)
    expect(comment.slack_user).to eq user
  end
end
