class Api::CommentsController < Api::ApplicationController
  before_action :set_mobile_user

  def create
    if current_debate
      CommentMaker.perform(debate: current_debate, user: @mobile_user, params: comment_params)

      head :created
    else
      render json: { error: 'Debate not found' }, status: :not_found
    end
  end

  private

  def set_mobile_user
    @mobile_user = MobileUser.find_by(auth_token: @auth_token)
  end

  def comment_params
    { content: params.fetch(:text) }
  end
end
