class DebatesController < ApplicationController
  def index
    @debates = Debate.all.to_a
  end

  def new
    @debate = Debate.new
  end

  def create
    @debate = Debate.new debate_params
    if @debate.save
      flash[:notice] = 'Debate was successfully created'
      redirect_to debates_path
    else
      render :new
    end
  end

  private

  def debate_params
    params.require(:debate).permit(:topic)
  end
end
