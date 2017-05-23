class Api::CommentsController < Api::ApplicationController

  def create
    if debate
      CommentMaker.call(comment_maker_params)

      head :created
    else
      render json: { error: 'Debate not found' }, status: :not_found
    end
  end

  private

  def comment_maker_params
    {
      debate_id: current_debate.id,
      comment_text: params.fetch(:text)
    }
  end
end
