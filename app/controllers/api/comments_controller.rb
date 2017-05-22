class Api::CommentsController < Api::ApplicationController

  def create
    if debate
      Api::CommentMaker.call(comment_maker_params)

      head :created
    else
      render json: { error: 'Debate not found' }, status: :not_found
    end
  end

  private

  def comment_maker_params
    {
      debate_id: debate.id,
      comment_text: params.fetch(:text)
    }
  end

  def debate
    @_debate ||= AuthToken.find_by_value(params.fetch(:auth_token)).debate
  end
end
