class Api::VotesController < Api::ApplicationController
  def create
    answer = @auth_token.debate.answers.find_by id: params[:id]
    if answer.present?
      answer.votes.create!
      head :created
    else
      render json: { error: 'Answer not found' }, status: :not_found
    end
  end
end
