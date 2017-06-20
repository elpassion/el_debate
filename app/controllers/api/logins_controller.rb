class Api::LoginsController < Api::ApplicationController
  skip_before_action :authenticate
  before_action :create_debate_auth_token

  def create
    user = MobileUser.new(user_params)
    if user.save
      render json: { auth_token: @auth_token.value, debate_closed: @debate.closed? }
    else
      render json: { error: user_errors(user) }, status: :bad_request
    end
  end

  private

  def user_errors(user)
    user.errors.full_messages.join(', ')
  end

  def create_debate_auth_token
    @debate = Debate.find_by code: params[:code]
    return render json: { error: 'Debate not found' }, status: :not_found unless @debate
    @auth_token = @debate.auth_tokens.create!
  end

  def user_params
    {
      name: params[:username],
      auth_token: @auth_token
    }
  end
end
