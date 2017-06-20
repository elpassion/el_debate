class Api::CommentsController < Api::ApplicationController
  before_action :update_and_set_user

  def create
    if current_debate
      Mobile::CommentMaker.perform(comment_maker_params)

      head :created
    else
      render json: { error: 'Debate not found' }, status: :not_found
    end
  end

  private

  def update_and_set_user
    @user = MobileUser.find_by(auth_token: @auth_token)
    @user.update(name: params.fetch(:username))
    @user
  end

  def comment_maker_params
    {
      auth_token_id: @auth_token.id,
      debate_id: current_debate.id,
      comment_text: params.fetch(:text),
      user_id: @user.id
    }
  end
end
