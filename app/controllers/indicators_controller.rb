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
  end

  def create
    @indicator = Indicator.new(indicator_params)
    authorize @indicator
    @indicator.save
    redirect_to indicator_path(@indicator)
  end

  def edit
    @indicator = Indicator.find(params[:id])
    authorize @indicator
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
    params.require(:indicator).permit(:nome, :sigla, :finalidade, :abrangencia, :unidade_de_medida, :qtd_apuracoes_ano, :qtd_metas_ano)
  end
end
