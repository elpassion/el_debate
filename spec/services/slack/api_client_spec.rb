require 'rails_helper'
describe Slack::ApiClient do
  describe "get_user_data" do
    let(:slack_id) { 'slack_id' }

    subject do
      Slack::ApiClient.new(network_provider)
    end

    let(:api_endpoint) do
      'https://slack.com/api/users.info'
    end

    context "all went good" do
      let(:network_provider) do
        Faraday.new do |builder|
          builder.adapter :test, nil do |stub|
            stub.get(api_endpoint) do |env|
              [200, {}, api_response.to_json]
            end
          end
        end
      end

      let(:api_response) do
        {
          user: {
            profile: {
              image_192: "image_url",
              real_name: "Slack User Name"
            }
          }
        }
      end

      it "returns correct user data" do
        expected = {
          user_image_url: 'image_url',
          user_name: 'Slack User Name'
        }
        expect(subject.get_user_data(slack_id)).to eq expected
      end
    end

    context "there was a network problem" do
      let(:network_provider) do
        Faraday.new do |builder|
          builder.adapter :test do |stub|
            stub.get(api_endpoint) do |env|
              [500, {}, 'error' ]
            end
          end
        end
      end

      it "raises a correct error" do
        expect {
          subject.get_user_data(slack_id)
        }.to raise_error(Slack::ApiNetworkError)
      end
    end
  end
end
