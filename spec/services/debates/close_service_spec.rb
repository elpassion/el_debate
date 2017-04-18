require 'rails_helper'

describe Debates::CloseService do
  let(:debate)       { create(:debate) }
  let(:notifier)     { instance_double('DebateNotifier') }
  let(:closing_time) { Time.current - 2.hours }
  subject            { described_class.new(debate: debate, notifier: notifier) }

  before do
    allow(notifier).to receive(:notify)
  end

  it 'closes debate' do
    subject.call
    expect(debate).to be_closed
  end

  it 'notifies about closing debate' do
    expect(notifier).to receive(:notify).with(debate)
    subject.call
  end

  it 'doesn\'t change closed_at time of closed debate' do
    debate.update(closed_at:  closing_time)
    expect{ subject.call }.not_to change{ debate.closed_at }
  end
end
