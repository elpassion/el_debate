require 'rails_helper'

describe Debates::CloseService do
  let(:debate) { create(:debate, closed_at: nil) }
  let(:message_broadcaster) { double('message broadcaster') }

  before do
    allow(message_broadcaster).to receive(:push)
  end

  it 'closes debate' do
    service = described_class.new(debate: debate, message_broadcaster: message_broadcaster)
    service.call
    expect(debate).to be_closed
  end

  it 'notifies about closing debate' do
    expect(message_broadcaster).to receive(:push).with("dashboard_channel_#{debate.id}", 'status', 'closed')

    service = described_class.new(debate: debate, message_broadcaster: message_broadcaster)
    service.call
  end
end
