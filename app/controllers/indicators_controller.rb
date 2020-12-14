class IndicatorsController < ApplicationController



  def index
    @indicators = Indicator.all
  end

  def show
    @indicator = Indicator.find(params[:id])
  end

  def new
    @indicator = Indicator.new
  end

  def create
    @indicator = Indicator.new(indicator_params)
    @indicator.save
    redirect_to indicator_path(@indicator)
  end

  def edit
    @indicator = Indicator.find(params[:id])
  end

  def update
    @indicator = Indicator.find(params[:id])
    @indicator.update(indicator_params)
    redirect_to indicator_path(@indicator)
  end

  def destroy
    @indicator = Indicator.find(params[:id])
    @indicator.destroy
    redirect_to indicator_path
  end

  private

  def indicator_params
    params.require(:indicator).permit(:nome, :sigla, :finalidade, :abrangencia, :unidade_de_medida, :qtd_apuracoes_ano, :qtd_metas_ano)
  end

end
