class Api::CommentsController < Api::ApplicationController
  before_action :set_mobile_user, only: [:create]
  before_action :require_current_debate

  def create
    update_mobile_user_identity
    CommentMaker.perform(debate: current_debate, user: @mobile_user, params: comment_params)
    head :created
  end

  def index
    render json: current_debate.retrieve_comments.map { |comment| CommentSerializer.new(comment) }
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
