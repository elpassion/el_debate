require 'rails_helper'

describe Api::CommentsController do
  describe "#create" do
    let(:params) do
      {
        text: "comment_text"
      }
    end

    context "when proper auth_token given" do
      let(:debate) { create(:debate) }
      let(:auth_token) { debate.auth_tokens.create }
      let!(:mobile_user) { create(:mobile_user, auth_token: auth_token)}

      before do
        request.env['HTTP_AUTHORIZATION'] = auth_token.value
      end

      it "executes the comment maker service" do
        expect(Mobile::CommentMaker).to receive(:perform).with(
            hash_including({
                               debate_id: debate.id,
                               comment_text: "comment_text"
                           })
        )

        post :create, params: params
      end
    end

    context "auth_token not given" do
      it "does not execute any of the service objects" do
        expect(Mobile::CommentMaker).not_to receive(:perform)

        post :create, params: params
      end
    end
  end
end
