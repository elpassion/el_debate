class DebatesController < ApplicationController
  def show
    @debate = Debate.find params[:id]
  end
end
