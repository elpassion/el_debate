class Api::ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :destroy_session, :authenticate

  rescue_from StandardError do |exception|
    render json: { error: exception.message }, status: :internal_server_error
  end

  private

  def destroy_session
    request.session_options[:skip] = true
  end

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @auth_token = AuthToken.find_by value: token
    end
  end
end
