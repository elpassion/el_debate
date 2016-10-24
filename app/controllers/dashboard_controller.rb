class DashboardController < ApplicationController
  def index
    debate = Debate.find(params[:id])
    @debate = DebatePresenter.new(debate)
  end
end
