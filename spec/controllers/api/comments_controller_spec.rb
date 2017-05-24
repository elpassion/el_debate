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

      before do
        request.env['HTTP_AUTHORIZATION'] = auth_token.value
      end

      it "executes the comment maker service" do
        expect(CommentMaker).to receive(:call).with(
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
        expect(CommentMaker).not_to receive(:call)

        post :create, params: params
      end
    end
  end
end
