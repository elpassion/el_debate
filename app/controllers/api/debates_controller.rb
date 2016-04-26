class Api::DebatesController < Api::ApplicationController
  def show
    render json: DebateSerializer.new(current_debate).to_json
  end
end
