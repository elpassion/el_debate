require 'rails_helper'

describe Debates::CloseService do
  let(:debate)       { create(:debate) }
  let(:notifier)     { instance_double('DebateNotifier') }
  subject            { described_class.new(debate: debate, notifier: notifier) }

  before do
    allow(notifier).to receive(:notify_about_closing)
  end

  it 'closes debate' do
    subject.call
    expect(debate).to be_closed
  end

  it 'notifies about closing debate' do
    expect(notifier).to receive(:notify_about_closing).with(debate)
    subject.call
  end
end
