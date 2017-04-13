require 'rails_helper'

describe Debates::CloseService do
  let(:debate) { create(:debate) }
  let(:message_broadcaster) { double('message broadcaster') }
  let(:closing_time) { Time.current - 2.hours }
  let(:service) {described_class.new(debate: debate, message_broadcaster: message_broadcaster)}

  before do
    allow(message_broadcaster).to receive(:push)
  end

  it 'closes debate' do
    service.call
    expect(debate).to be_closed
  end

  it 'notifies about closing debate' do
    expect(message_broadcaster).to receive(:push).with("dashboard_channel_#{debate.id}", 'status', 'closed')
    service.call
  end

  it 'doesn\'t change closed_at time of closed debate' do
    debate.update(closed_at:  closing_time)
    expect{ service.call }.not_to change{ debate.closed_at }
  end
end
