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
    @goals = policy_scope(Goal).sort
    @goal = Goal.new
    @indicators = Indicator.all
    authorize @goal
  end

  def create
    @goal = Goal.new(goal_params)
    authorize @goal
    if @goal.save
      redirect_to new_goal_path(@goal), notice: "Meta cadastrada com sucesso"
    else
      @goals = policy_scope(Goal).sort
      render :new
    end
  end

  def edit
    @goal = Goal.find(params[:id])
    @goals = policy_scope(Goal).sort
    authorize @goal
    @indicators = Indicator.all
  end

  def update
    @goal = Goal.find(params[:id])
    authorize @goal
    if @goal.update(goal_params)
      redirect_to edit_goal_path(@goal), notice: "Meta alterada com sucesso"
    else
      @goals = policy_scope(Goal).sort
      render :edit
    end
  end

  def destroy
    @goal = Goal.find(params[:id])
    authorize @goal
    if @goal.destroy
      redirect_to edit_goal_path("1"), notice: "Meta excluída com sucesso"
    else
      render :edit
    end
  end

  private

  def goal_params
    params.require(:goal).permit(:ano, :periodo, :valor, :indicator_id)
  end
end


