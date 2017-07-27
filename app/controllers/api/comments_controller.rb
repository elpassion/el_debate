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

  private

  def set_mobile_user
    @mobile_user = MobileUser.find_by(auth_token: @auth_token)
  end

  def comment_params
    { content: params.fetch(:text) }
  end

  def update_mobile_user_identity
    return if first_and_last_name_present?
    @mobile_user.update(
      first_name: params.dig(:first_name),
      last_name: params.dig(:last_name)
    )
  end

  def first_and_last_name_present?
    @mobile_user.first_name.present? && @mobile_user.last_name.present?
  end
end
