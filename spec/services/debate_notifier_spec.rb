require 'rails_helper'

describe DebateNotifier do
  let(:debate)      { create(:debate) }
  let(:channel)     { "dashboard_channel_#{debate.code}" }
  let(:broadcaster) { instance_double(PusherBroadcaster) }
  subject           { described_class.new(broadcaster: broadcaster) }

  it 'notifies about debate current state' do
    expect(broadcaster).to receive(:push).with(channel, 'debate_changed', hash_including(:debate))
    subject.notify_about_votes(debate)
  end

  it 'notifies about opening of debate' do
    expect(broadcaster).to receive(:push).with(channel, 'debate_opened', {})
    subject.notify_about_opening(debate)
  end

  it 'notifies about closing of debate' do
    expect(broadcaster).to receive(:push).with(channel, 'debate_closed', {})
    subject.notify_about_closing(debate)
  end

  it 'notifies about debate reset' do
    expect(broadcaster)
      .to receive(:push).with(channel, 'debate_reset', hash_including(:debate))
    subject.notify_about_reset(debate)
  end
end
