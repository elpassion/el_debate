class Api::VotesController < Api::ApplicationController
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
