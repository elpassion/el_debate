require 'rails_helper'

shared_examples 'abstract comment maker' do
  describe "#call" do
    it "creates a new comment" do
      expect {
        subject.call(params)
      }.to change(model, :count).by(1)
    end

    it "executes a CommentNotifier service" do
      expect(notifier_mock).to receive(:call)
      subject.call(params)
    end
  end
end
