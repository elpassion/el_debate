require 'rails_helper'

describe DebateNotifier do
  subject           { DebateNotifier.new(broadcaster) }
  let(:debate)      { create(:debate) }
  let(:channel)     { "dashboard_channel_#{debate.id}" }
  let(:broadcaster) { double('PusherBroadcaster') }

  it 'notifies about debate current state' do
    expect(broadcaster)
      .to receive(:push).with(channel, 'debate_changed', hash_including(:debate))
    subject.notify_about_votes(debate)
  end

  it 'notifies about opening of debate' do
    expect(broadcaster)
        .to receive(:push).with(channel, 'debate_opened', {})
    subject.notify_about_opening(debate)
  end

  it 'notifies about closing of debate' do
    expect(broadcaster)
        .to receive(:push).with(channel, 'debate_closed', {})
    subject.notify_about_closing(debate)
  end

  it 'notifies about debate reset' do
    expect(broadcaster)
        .to receive(:push).with(channel, 'debate_reset', hash_including(:debate))
    subject.notify_about_reset(debate)
  end

  context 'with vote changes' do
    let(:vote_change) { instance_double('VoteChange') }
    let(:changes) { {vote_change: {positive: 1, negative: 0}} }

    before do
      allow(vote_change)
        .to receive(:to_h).and_return(changes)
    end

    it 'notifies about vote change' do
      expect(broadcaster)
        .to receive(:push).with(channel, 'debate_changed', hash_including(:debate, changes))

      subject.notify_about_votes(debate, vote_change)
    end
  end

end
