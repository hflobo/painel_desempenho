class IndicatorsController < ApplicationController
  before_action :authenticate_user!

  def index
    @indicators = policy_scope(Indicator).includes(:region, :objective)
  end

  def show
    @indicator = Indicator.find(params[:id])
    authorize @indicator
  end

  def new
    @indicator = Indicator.new
    authorize @indicator
    @regions = Region.all
    @objectives = Objective.all
  end

  def create
    @indicator = Indicator.new(indicator_params)
    authorize @indicator
    @indicator.user_id = current_user.id
    if @indicator.save!
      redirect_to indicators_path(@indicator), notice: "Indicador criado com sucesso"
    else
      render :new
    end
  end

  def edit
    @indicator = Indicator.find(params[:id])
    authorize @indicator
    @regions = Region.all
    @objectives = Objective.all
  end

  def update
    @indicator = Indicator.find(params[:id])
    authorize @indicator
    @indicator.update(indicator_params)
    redirect_to indicator_path(@indicator)
  end

  def destroy
    @indicator = Indicator.find(params[:id])
    authorize @indicator
    @indicator.destroy
    redirect_to indicator_path
  end

  private

  def indicator_params
    params.require(:indicator).permit(:nome, :sigla, :finalidade, :abrangencia, :unidade_de_medida, :qtd_apuracoes_ano, :qtd_metas_ano, :region_id, :objective_id)
  end
end
