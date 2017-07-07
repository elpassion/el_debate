class Api::CommentsController < Api::ApplicationController
  before_action :set_user
  before_action :update_username_if_changed

  def create
    if current_debate
      CommentMaker.perform(debate: current_debate, user: @user, comment_class: MobileComment, params: comment_params)

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

  def comment_params
    { content: params.fetch(:text) }
  end
end
