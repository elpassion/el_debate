require 'rails_helper'

describe DebateNotifier do
  subject           { DebateNotifier.new(broadcaster) }
  let(:debate)      { create(:debate) }
  let(:channel)     { "dashboard_channel_#{debate.id}" }
  let(:broadcaster) { double('PusherBroadcaster') }
  let(:event)       { 'debate_changed' }

  it 'notifies about debate current state' do
    expect(broadcaster)
      .to receive(:push).with(channel, event, hash_including(:debate))
    subject.notify(debate)
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
        .to receive(:push).with(channel, event, hash_including(:debate, changes))

      subject.notify(debate, vote_change)
    end
  end

end
