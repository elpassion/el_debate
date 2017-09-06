class Api::DebatesController < Api::ApplicationController
  before_action :require_current_debate_not_closed
  def show
    render json: DebateSerializer.new(current_debate, @auth_token.id).to_json
  end
end
