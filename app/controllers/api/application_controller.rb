class Api::ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  rescue_from StandardError do |exception|
    render json: { error: exception.message }, status: :internal_server_error
  end
end
