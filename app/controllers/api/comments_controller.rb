class Api::CommentsController < Api::ApplicationController

  def create
    if current_debate
      Mobile::CommentMaker.perform(comment_maker_params)

      head :created
    else
      render json: { error: 'Debate not found' }, status: :not_found
    end
  end

  private

  def user
    @_user ||= MobileUser.find_by(
        auth_token_id: @auth_token.id
    )
  end

  def user_maker_params
    {
      name: params.fetch(:username),
      auth_token_id: @auth_token.id
    }
  end

  def comment_maker_params
    {
      debate_id: current_debate.id,
      comment_text: params.fetch(:text)
    }
  end
end
