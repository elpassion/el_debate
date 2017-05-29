require 'rails_helper'

describe SlugGenerator do
  describe "call" do
    let(:code_generator) do
      double(
        generate: '12345'
      )
    end


    subject do
      SlugGenerator.new(:name, code_generator).call(object)
    end

    context "short topic" do
      let(:object) do
        double(
          name: "this is my name"
        )
      end

      it "generates slug based on a given attribute" do
        expect(subject).to eq "this-is-my-name-12345"
      end
    end

    context "too long topic" do
      let(:object) do
        double(
          name: "this is my name and it is too long for slug to look nice for people to see"
        )
      end

      it "generates slug based on a given attribute but shortens it" do
        expect(subject).to eq "this-is-my-name-and-it-12345"
      end
    end
  end
end
