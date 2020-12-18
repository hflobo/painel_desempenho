class KpisController < ApplicationController

  before_action :set_kpi, only: [:edit, :update, :destroy]

  def new
    @kpi = Kpi.new
    @indicators = Indicator.all.order(id: :asc)
    @dashboard = Dashboard.find(params[:dashboard_id])
    @kpi.dashboard = @dashboard
    authorize(@kpi)
  end

  def create
    @kpi = Kpi.new(kpi_params)
    @kpi.dashboard_id = params[:dashboard_id]
    @kpi.dashboard = Dashboard.find(params[:dashboard_id])

    authorize(@kpi)

    if @kpi.valid?
      @kpi.reordenar!(@kpi.id, @kpi.ordem, @kpi.dashboard.kpis.length)
      @kpi.save
      redirect_to dashboard_path(@kpi.dashboard_id)
    else
      @dashboard = @kpi.dashboard
      render :new
    end
  end

  def edit
    @indicators = Indicator.all.order(id: :asc)
    @dashboard = Dashboard.find(params[:dashboard_id])

  end

  def update
    ordem_velha = @kpi.ordem
    @kpi.ordem = kpi_params[:ordem]
    if @kpi.valid?
      @kpi.reordenar!(@kpi.id, @kpi.ordem.to_i, ordem_velha)
      @kpi.update(kpi_params)
      redirect_to dashboard_path(@kpi.dashboard_id)
    else
      @dashboard = @kpi.dashboard
      render :edit
    end
  end

  def destroy
    dashboard_id = @kpi.dashboard_id
    if @kpi.valid?
      @kpi.reordenar!(@kpi.id, @kpi.dashboard.kpis.length, @kpi.ordem)
      @kpi.destroy
      redirect_to dashboard_path(dashboard_id)
    end
  end

  private

  def set_kpi
    @kpi = Kpi.find(params[:id])
    authorize @kpi
  end

  def kpi_params
    params.require(:kpi).permit(:indicator_id, :nome, :ordem, :tipo_grafico, :destaque)
  end

end
