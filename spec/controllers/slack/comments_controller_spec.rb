require 'rails_helper'

describe Slack::CommentsController do
  describe '#create' do
    let(:slack_params) do
      {
        user_id:      '1',
        channel_name: 'debate_channel',
        text:         'comment_text'
      }
    end

    context 'when it is a first comment by a given user' do
      let!(:debate) { create(:debate, channel_name: 'debate_channel') }

      it 'executes the slack user maker job' do
        expect(Slack::UserMaker).to receive(:perform_later).with(hash_including({ slack_user_id: '1' }))

        post :create, params: slack_params
      end
    end

    context 'when it is not a first comment by a given user' do
      let!(:debate) { create(:debate, channel_name: 'debate_channel') }
      let!(:slack_user) { create(:slack_user, slack_id: '1') }

      it 'executes the comment maker service' do
        expect(CommentMaker).to receive(:perform).with(
          hash_including({
            debate:         debate,
            user:           slack_user,
            comment_class:  SlackComment,
            params:         { content: 'comment_text' }
          })
        )

        post :create, params: slack_params
      end
    end

    context 'when debate was not found' do
      it 'does not execute any of the services' do
        expect(CommentMaker).not_to receive(:perform)
        expect(Slack::UserMaker).not_to receive(:perform_later)

        post :create, params: slack_params
      end
    end
  end
end