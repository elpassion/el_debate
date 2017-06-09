require 'rails_helper'

describe Debates::OpenService do
  let(:debate)   { create(:debate, :closed_debate) }
  let(:notifier) { instance_double('DebateNotifier') }
  subject        { described_class.new(debate: debate, notifier: notifier) }
  let(:message_broadcaster) { double('message broadcaster') }

  before do
    allow(notifier).to receive(:notify_about_opening)
  end

  it 'opens debate' do
    subject.call
    expect(debate).not_to be_closed
  end

  it 'notifies about opening debate' do
    expect(notifier).to receive(:notify_about_opening).with(debate)
    subject.call
  end
end
