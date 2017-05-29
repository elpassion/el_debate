class DashboardController < ApplicationController
  def index
    debate = Debate.find_by!(slug: params[:slug])
    @debate = DebatePresenter.new(debate)
  end
end
