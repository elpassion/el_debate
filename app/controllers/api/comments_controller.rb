class Api::CommentsController < Api::ApplicationController
  DEFAULT_LIMIT = 10

  before_action :set_user, only: [:create]
  before_action :require_current_debate, :require_current_debate_not_closed, only: [:create]

  def create
    update_user_identity
    comment = CommentMaker.perform(debate: current_debate, user: @user, params: comment_params)
    render json: CommentSerializer.new(comment), status: :created
  end

  def index
    comments_stream = ARStream.build(:backward, current_debate.retrieve_comments, start_at: position)
    render json: { debate_closed: current_debate.closed?,
                   comments: comments_stream.next(limit).map { |comment| CommentSerializer.new(comment) } }
  end

  private

  def set_user
    @user = User.find_by(auth_token: @auth_token)
  end

  def comment_params
    { content: params.fetch(:text) }
  end

  def update_user_identity
    UserIdentity.new(@user).update(first_name: params.dig(:first_name),
                                   last_name: params.dig(:last_name))
  end

  def limit
    limit = params[:limit].to_i
    return DEFAULT_LIMIT if limit.zero?

    limit
  end

  def position
    position = params[:position].to_i
    return nil if position.zero?

    position
  end
end
