require 'rails_helper'

describe Slack::CommentsController do
  describe "#create" do
    let(:slack_params) do
      {
        user_id: "existing_user_id",
        channel_name: "debate_channel",
        text: "comment_text"
      }
    end

    context "first comment by a given user" do
      before do
        create(:debate, channel_name: "debate_channel")
      end

      it "executes the slack user maker job" do
        expect(Slack::UserMaker).to receive(:perform_later).with(
          hash_including({
            slack_user_id: "existing_user_id",
            comment_text: "comment_text"
          })
        )

        post :create, params: slack_params
      end
    end

    context "not the first comment by a given user" do
      before do
        create(:debate, channel_name: "debate_channel")
        create(:slack_user, slack_id: slack_params.fetch(:user_id))
      end

      it "executes the comment maker service" do
        expect(Slack::CommentMaker).to receive(:call).with(
          hash_including({
            slack_user_id: "existing_user_id",
            comment_text: "comment_text"
          })
        )

        post :create, params: slack_params
      end
    end

    context "debate not found by a given name" do
      it "does not execute any of the service objects" do
        expect(Slack::CommentMaker).not_to receive(:call)
        expect(Slack::UserMaker).not_to receive(:perform_later)

        post :create, params: slack_params
      end
    end
  end
end
