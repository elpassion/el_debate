class Api::LoginsController < Api::ApplicationController
  skip_before_action :authenticate
  before_action :create_debate_auth_token

  def create
    form = MobileUserForm.new(::MobileUser.new)
    if form.validate(user_params.merge(auth_token: @auth_token))
      form.save
      render json: { auth_token: @auth_token, debate_closed: @auth_token.debate.closed? }
    else
      render json: { error: form.error_messages }, status: :bad_request
    end
  end

  private

  def create_debate_auth_token
    debate = Debate.find_by code: params[:code]
    return render json: { error: 'Debate not found' }, status: :not_found unless debate
    @auth_token = debate.auth_tokens.create!
  end

  def user_params
    { name: params[:username] }
  end
end
