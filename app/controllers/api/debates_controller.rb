class Api::DebatesController < Api::ApplicationController
  def show
    render json: DebateSerializer.new(current_debate, @auth_token.id).to_json
  end
end
