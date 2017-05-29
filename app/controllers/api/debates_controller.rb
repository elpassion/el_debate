class Api::DebatesController < Api::ApplicationController
  def show
    render json: DebateSerializer.new(current_debate, @auth_token).to_json
  end
end
