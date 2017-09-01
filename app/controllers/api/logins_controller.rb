class Api::LoginsController < Api::ApplicationController
  skip_before_action :authenticate
  before_action :create_debate_auth_token, :set_user, :require_current_debate_not_closed

  def create
    if @user.save
      render json: { user_id: @user.id, auth_token: @auth_token.value, debate_closed: @debate.closed? }
    else
      render json: { error: 'User invalid' }, status: :bad_request
    end
  end

  private

  def create_debate_auth_token
    @debate = Debate.find_by code: params[:code]
    return render json: { error: 'Debate not found' }, status: :not_found unless @debate
    @auth_token = @debate.auth_tokens.create!
  end

  def set_user
    @user = User.new(user_params)
  end

  def user_params
    {
      auth_token: @auth_token
    }
  end
end
