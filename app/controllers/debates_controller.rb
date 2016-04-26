class DebatesController < ApplicationController
  def index
    @debates = Debate.all.to_a
  end

  def show
    @debate = Debate.find params[:id]
  end

  def new
    @debate = Debate.new
  end

  def create
    @debate = Debate.new debate_params
    if @debate.save
      flash[:notice] = 'Debate was created successfully'
      redirect_to @debate
    else
      render :new
    end
  end

  private

  def debate_params
    params.require(:debate).permit(:topic)
  end
end
