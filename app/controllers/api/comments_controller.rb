class Api::CommentsController < Api::ApplicationController
  before_action :set_mobile_user

  def create
    if current_debate
      update_mobile_user_identity
      CommentMaker.perform(debate: current_debate, user: @mobile_user, params: comment_params)

      head :created
    else
      render json: { error: 'Debate not found' }, status: :not_found
    end
  end

  def index
    if current_debate
      comments = GetComments.new(current_debate.id).to_h

      render json: comments, status: 200
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

  def update_mobile_user_identity
    MobileUserIdentity.new(@mobile_user).update(first_name: params.dig(:first_name),
                                                last_name: params.dig(:last_name))
  end
end
