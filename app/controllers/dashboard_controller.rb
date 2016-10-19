class DashboardController < ApplicationController
  def index
    @debate = Debate.find(params[:id])
  end
end
