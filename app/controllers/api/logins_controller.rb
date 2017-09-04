class Api::LoginsController < Api::ApplicationController
  skip_before_action :authenticate
  before_action :require_current_debate,
                :require_current_debate_not_closed

  def create
    user = Debates::AccessService.new(debate: current_debate).login
    render json: AuthSerializer.new(user, current_debate)
  end

  private

  def current_debate
    return @_current_debate if defined?(@_current_debate)
    @_current_debate = Debate.find_by code: params[:code]
  end
end
