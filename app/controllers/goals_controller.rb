class GoalsController < ApplicationController

  before_action :authenticate_user!
  
  def index
    @goals = policy_scope(Goal)
  end

  def show
    @goal = Goal.find(params[:id])
    authorize @goal
  end

  def new
    @indicator = Indicator.find(params[:id]) unless params[:id].nil?
    @goals = policy_scope(Goal) 
    @goal = Goal.new
    @indicators = Indicator.all
    authorize @goal
  end

  def create
    @goal = Goal.new(goal_params)
    authorize @goal
#    @goal.user_id = current_user.id
    if @goal.save!
      redirect_to goals_path(@goal), notice: "Meta foi cadastrada com sucesso"
    else
      render :new
    end
  end

  def edit
    @goal = Goal.find(params[:id])
    @goals = policy_scope(Goal)
    authorize @goal
    @indicators = Indicator.all
  end

  def update
    @goal = Goal.find(params[:id])
    authorize @goal
    @goal.update(goal_params)
    redirect_to goal_path(@goal)
  end

  def destroy
    @goal = Goal.find(params[:id])
    authorize @goal
    @goal.destroy
    redirect_to goals_path
  end

  private

  def goal_params
    params.require(:Goal).permit(:ano, :periodo, :valor, :indicator_id)
  end
end


