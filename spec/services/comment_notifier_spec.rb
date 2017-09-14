require 'rails_helper'

describe CommentNotifier do
  let(:debate) { create(:debate) }
  let(:comment) { create(:comment) }

  let(:broadcaster) { instance_double(PusherBroadcaster) }
  subject { described_class.new(broadcaster: broadcaster) }

  it 'notify comment added' do
    expect(broadcaster).to receive(:push).with("dashboard_channel_#{debate.code}",
                                               'comment_added',
                                               hash_including(content: comment.content))

    subject.comment_added(comment: comment, channel: "dashboard_channel_#{debate.code}")
  end

  it 'notify comments added' do
    expect(broadcaster).to receive(:push).with("dashboard_channel_multiple_#{debate.code}",
                                               'comments_added',
                                               array_including(hash_including(content: comment.content)))

    subject.comments_added(comments: [comment], channel: "dashboard_channel_multiple_#{debate.code}")
  end

  it 'notify comment reject' do
    expect(broadcaster).to receive(:push).with("user_channel_#{comment.user_id}",
                                               'comment_rejected',
                                               hash_including(content: comment.content))

    subject.comment_rejected(comment: comment, channel: "user_channel_#{comment.user_id}")
  end
end
