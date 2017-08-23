class DashboardController < ApplicationController
  def index
    debate = Debate.find_by!(slug: params[:slug])
    @debate = DebatePresenter.new(debate)

    @right = {
      positive: true,
      value: @debate.positive_value,
      percent: @debate.positive_percent,
      count: @debate.positive_count
    }
    
    @left = {
      positive: false,
      value: @debate.negative_value,
      percent: @debate.negative_percent,
      count: @debate.negative_count
    }
  end
end
