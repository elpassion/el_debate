class Api::CommentsController < Api::ApplicationController
  before_action :set_user
  before_action :update_username_if_changed

  def create
    if current_debate
      Mobile::CommentMaker.perform(comment_maker_params)

      head :created
    else
      render json: { error: 'Debate not found' }, status: :not_found
    end
  end

  private

  def set_user
    @user = MobileUser.find_by(auth_token: @auth_token)
  end

  def update_username_if_changed
    @user.update_attribute(:name, params.fetch(:username))
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
