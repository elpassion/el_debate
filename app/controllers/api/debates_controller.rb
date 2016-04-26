class Api::DebatesController < Api::ApplicationController
  def show
    render json: DebateSerializer.new(@auth_token.debate).to_json
  end
end
