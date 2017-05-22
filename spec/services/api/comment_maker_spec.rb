require 'rails_helper'

describe Api::CommentMaker do
  let(:model) { Comment }

  let(:notifier_mock) do
    double(:comment_notifier, call: nil)
  end

  let(:params) do
    {
        comment_text: "No agree",
        debate_id: 123
    }
  end

  subject do
    Api::CommentMaker.new(notifier_mock)
  end

  it_behaves_like "abstract comment maker"
end
