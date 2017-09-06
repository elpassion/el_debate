require 'rails_helper'

describe Api::CommentsController do
  let(:params) { { text: 'comment_text', username: 'username' } }
  let(:debate) { create(:debate) }
  let(:auth_token) { create(:auth_token, debate: debate) }
  let(:token_value) { auth_token.value }
  let!(:user) { create(:user, auth_token: auth_token, first_name: 'John', last_name: 'Doe') }

  before(:all) do
    Timecop.freeze(Time.local(2017, 8, 5, 10, 10, 10))
  end

  before do
    request.env['HTTP_AUTHORIZATION'] = token_value
  end

  after do
    Timecop.return
  end

  describe '#create' do
    subject do
      post :create, params: params
      response
    end

    let(:json_response) { JSON.parse(subject.body) }

    it 'executes the comment maker service' do
      expect(CommentMaker).to receive(:perform).with(
        hash_including({
                         debate: debate,
                         user: user,
                         params: { content: 'comment_text' }
                       })
      )

      subject
    end

    context 'when auth_token was not given' do
      let(:token_value) { '' }

      it 'does not execute any of the services' do
        expect(CommentMaker).not_to receive(:perform)

        expect(subject).to have_http_status(:unauthorized)
      end
    end

    context 'when debate is closed' do
      let(:debate) { create(:debate, :closed_debate) }

      it 'returns not_acceptable status with error message on comments create' do
        expect(subject).to have_http_status(:not_acceptable)
        expect(json_response).to include('error' => 'Debate is closed')
      end
    end
  end

  describe '#index' do
    subject do
      get :index
      response
    end

    let(:json_response) { JSON.parse(subject.body) }

    context 'when comments are created and have status active' do
      let!(:comment) { create(:comment, user: user, debate: debate, status: :accepted) }

      let(:expected_json_response) do
        {
          'debate_closed' => false,
          'comments' => [
            "id" => comment.id,
            "content" => comment.content,
            "full_name" => user.full_name,
            "created_at" => Time.now.to_i * 1000,
            "user_initials_background_color" => user.initials_background_color,
            "user_initials" => user.initials,
            "user_id" => user.id,
            "status" => comment.status
          ]
        }
      end

      it 'retrieve valid status' do
        expect(subject).to have_http_status(:ok)
        expect(json_response).to eq(expected_json_response)
      end
    end

    context 'when comments are not created' do
      it 'retrieve valid status and empty array of comments' do
        expect(subject).to have_http_status(:ok)
        expect(json_response).to eq({ "debate_closed" => false,
                                      "comments" => [] })
      end
    end

    context 'when comments are created, but status is pending' do
      before do
        create(:comment, user: user, debate: debate, status: :pending)
        create(:comment, user: user, debate: debate, status: :pending)
      end

      it 'retrieve valid status and empty array of comments' do
        expect(subject).to have_http_status(:ok)
        expect(json_response).to eq("debate_closed" => false,
                                    "comments" => [])
      end
    end

    context 'when debate is closed' do
      let(:debate) { create(:debate, :closed_debate, :with_comments, comments_status: :accepted) }

      let(:comment_matcher) do
        hash_including(
          'id',
          'content',
          'full_name',
          'created_at',
          'user_initials_background_color',
          'user_initials',
          'user_id',
          'status'
        )
      end

      it 'returns comment list' do
        expect(subject).to have_http_status(:ok)
        expect(json_response).to include('comments' => array_including(comment_matcher))
        expect(json_response).to include("debate_closed" => true)
      end
    end
  end
end
