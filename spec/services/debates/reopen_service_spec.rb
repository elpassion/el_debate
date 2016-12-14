require 'rails_helper'

describe Debates::ReopenService do
  let(:debate) { create(:debate, closed_at: Time.now) }
  let(:message_broadcaster) { double('message broadcaster') }

  before do
    allow(message_broadcaster).to receive(:push)
  end

  it 'closes debate' do
    service = described_class.new(debate: debate, message_broadcaster: message_broadcaster)
    service.call
    expect(debate).not_to be_closed
  end

  it 'notifies about closing debate' do
    expect(message_broadcaster).to receive(:push).with("dashboard_channel_#{debate.id}", 'status', 'reopened')

    service = described_class.new(debate: debate, message_broadcaster: message_broadcaster)
    service.call
  end
end
