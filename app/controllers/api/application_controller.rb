class Api::ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :destroy_session, :authenticate

  rescue_from StandardError do |exception|
    ExceptionNotifier.notify_exception(exception)
    render json: { error: exception.message }, status: :internal_server_error
  end

  private

  def destroy_session
    request.session_options[:skip] = true
  end

  def authenticate
    @auth_token = TokenRequester.new(request.headers).auth_token

    head :unauthorized unless @auth_token
  end

  def current_debate
    return unless @auth_token.present?
    @auth_token.debate
  end
end
