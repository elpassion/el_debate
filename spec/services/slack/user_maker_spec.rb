require 'rails_helper'

describe Slack::UserMaker do
  subject do
    Slack::UserMaker.new.perform(params)
  end

  let(:params) do
    {
      slack_user_id: "slack_user_id"
    }
  end

  describe "perform" do
    context "all went good" do
      before do
        allow(Slack::CommentMaker).to receive(:perform)
      end

      before do
        Slack::UserMaker.slack_api_client = double(:slack_api_client,
          get_user_data: {
            user_image_url: "image_url",
            user_name: "Slack User Name"
          }
        )
      end

      it "creates a new user" do
        expect {
          subject
        }.to change(SlackUser, :count).by(1)
      end

      it "executes a CommentMaker service with correct params" do
        expect(Slack::CommentMaker).to receive(:perform).with(
          hash_including(params)
        )
        subject
      end

      it "fetches user image url and name from Slack api" do
        user = subject
        expect(user.name).to eq "Slack User Name"
        expect(user.image_url).to eq "image_url"
      end
    end

    context "there was a problem fetching data" do
      before do
        Slack::UserMaker.slack_api_client = double(:slack_api_client).tap do |client|
          allow(client).to receive(:get_user_data) {
            raise Slack::ApiNetworkError, 'Error'
          }
        end
      end

      it "does not create a new user" do
        expect {
          subject
        }.not_to change(SlackUser, :count)
      end

      it "does not execute CommentMaker" do
        expect(Slack::CommentMaker).not_to receive(:perform)
        subject
      end
    end
  end
end
