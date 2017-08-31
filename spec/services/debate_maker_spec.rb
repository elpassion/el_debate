require 'rails_helper'

describe DebateMaker do
  describe "#call" do
    let(:params) do
      {
        topic: "Our debate topic"
      }
    end

    subject do
      DebateMaker
    end

    let(:debate) { subject.call(params) }

    it "creates a new debate" do
      expect {
        subject.call(params)
      }.to change(Debate, :count).by(1)
    end

    it "assigns a slug to debate" do
      expect(debate.slug).not_to be_blank
    end

    it "assigns a code to debate" do
      expect(debate.code).not_to be_blank
    end

    it "assigns default answers to debate" do
      expect(debate.answers.count).to eq 3
    end
  end
end
