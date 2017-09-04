class Api::VotesController < Api::ApplicationController
  before_action :require_current_debate, :require_current_debate_not_closed

  def create
    answer = current_debate.answers.find_by id: params[:id]
    if answer.present?
      VoteService.new(answer: answer, auth_token: @auth_token).vote!
      head :created
    else
      render json: { error: 'Answer not found' }, status: :not_found
    end
  end
end
