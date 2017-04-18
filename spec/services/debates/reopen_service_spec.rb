require 'rails_helper'

describe Debates::ReopenService do
  let(:debate)   { create(:debate, closed_at: Time.now) }
  let(:notifier) { instance_double('DebateNotifier') }
  subject        { described_class.new(debate: debate, notifier: notifier) }
  let(:message_broadcaster) { double('message broadcaster') }

  before do
    allow(notifier).to receive(:notify)
  end

  it 'closes debate' do
    subject.call
    expect(debate).not_to be_closed
  end

  it 'notifies about closing debate' do
    expect(notifier).to receive(:notify).with(debate)
    subject.call
  end
end
