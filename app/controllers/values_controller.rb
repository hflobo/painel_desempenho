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
    @values = policy_scope(Value).sort
    @value = Value.new
    @indicators = Indicator.all
    authorize @value
  end

  def create
    @value = Value.new(value_params)
    authorize @value
    if @value.save
      redirect_to new_value_path(@value), notice: "Valor cadastrado com sucesso"
    else
      @values = policy_scope(Value).sort
      render :new
    end
  end

  def edit
    @value = Value.find(params[:id])
    @values = policy_scope(Value).sort
    authorize @value
    @indicators = Indicator.all
  end

  def update
    @value = Value.find(params[:id])
    authorize @value
    if @value.update(value_params)
      redirect_to edit_value_path(@value), notice: "Valor alterado com sucesso"
    else
      @values = policy_scope(Value).sort
      render :edit
    end
  end

  def destroy
    @value = Value.find(params[:id])
    authorize @value
    if @value.destroy
      redirect_to edit_value_path("1"), notice: "Valor excluído com sucesso"
    else
      render :edit
    end
  end

  private

  def value_params
    params.require(:value).permit(:ano, :periodo, :valor, :indicator_id)
  end
end
