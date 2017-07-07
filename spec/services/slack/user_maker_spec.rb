require 'rails_helper'

describe Slack::UserMaker do
  let(:params) {{ slack_user_id: '1' }}
  subject { described_class.new.perform(params) }

  describe '#perform' do
    let(:slack_api_client) { instance_double(Slack::ApiClient) }
    before { described_class.slack_api_client = slack_api_client }

    context 'when all went good' do
      before do
        allow(slack_api_client).to receive(:get_user_data) {{ user_image_url: 'image/url', user_name: 'Slack User Name' }}
      end

      it 'creates a new user' do
        expect { subject }.to change(SlackUser, :count).by(1)
      end

      it 'returns a user with correct params' do
        user = subject
        expect(user.name).to eq 'Slack User Name'
        expect(user.image_url).to eq 'image/url'
      end
    end

    context 'when there was a problem fetching data' do
      before do
        allow(slack_api_client).to receive(:get_user_data) { raise Slack::ApiNetworkError, 'Error' }
      end

      it 'does not create a new user' do
        expect { subject }.not_to change(SlackUser, :count)
      end
    end
  end
end