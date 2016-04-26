class Api::LoginsController < Api::ApplicationController
  skip_before_action :authenticate

  def create
    debate = Debate.find_by code: params[:code]
    if debate.present?
      auth_token = debate.auth_tokens.create
      render json: { auth_token: auth_token.value }
    else
      render json: { error: 'Debate not found' }, status: :not_found
    end
  end
end
