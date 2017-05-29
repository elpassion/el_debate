require 'rails_helper'

describe DebateMaker do
  describe "#call" do
    let(:params) do
      {
        topic: "Our debate topic",
        channel_name: "slack_debate_channel"
      }
    end

    subject do
      DebateMaker.call(params)
    end

    it "creates a new debate" do
      expect {
        subject
      }.to change(Debate, :count).by(1)
    end

    it "assigns a slug to debate" do
      debate = subject
      expect(debate.slug).not_to be_blank
    end

    it "assigns a code to debate" do
      debate = subject
      expect(debate.code).not_to be_blank
    end

    it "assigns default answers to debate" do
      debate = subject
      expect(debate.answers.count).to eq 3
    end
  end
end
