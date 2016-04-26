class TApi::ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :destroy_session

  rescue_from StandardError do |exception|
    render json: { error: exception.message }, status: :internal_server_error
  end

  private

  def destroy_session
    request.session_options[:skip] = true
  end
end
