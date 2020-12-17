class ValuesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @values = policy_scope(Value)
  end

  def show
    @value = Value.find(params[:id])
    authorize @value
  end

  def new
    @indicator = Indicator.find(params[:id]) unless params[:id].nil?
    @values = policy_scope(Value) 
    @value = Value.new
    @indicators = Indicator.all
    authorize @value
  end

  def create
    @value = Value.new(value_params)
    authorize @value
#    @value.user_id = current_user.id
    if @value.save!
      redirect_to values_path(@value), notice: "Valor foi cadastrado com sucesso"
    else
      render :new
    end
  end

  def edit
    @value = Value.find(params[:id])
    @values = policy_scope(Value)
    authorize @value
    @indicators = Indicator.all
  end

  def update
    @value = Value.find(params[:id])
    authorize @value
    @value.update(value_params)
    redirect_to value_path(@value)
  end

  def destroy
    @value = Value.find(params[:id])
    authorize @value
    @value.destroy
    redirect_to values_path
  end

  private

  def value_params
    params.require(:value).permit(:ano, :periodo, :valor, :indicator_id)
  end
end
