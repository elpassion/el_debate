class Api::LoginsController < Api::ApplicationController
  skip_before_action :authenticate
  before_action :create_debate_auth_token, :set_mobile_user

  def create
    if @mobile_user.save
      render json: { auth_token: @auth_token.value, debate_closed: @debate.closed? }
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

  def set_mobile_user
    @mobile_user = MobileUser.new(mobile_user_params)
  end

  def mobile_user_params
    {
      auth_token: @auth_token
    }
  end
end
