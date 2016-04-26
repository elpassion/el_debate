class Api::DebatesController < Api::ApplicationController
  def show
    render json: @auth_token.debate
  end
end
