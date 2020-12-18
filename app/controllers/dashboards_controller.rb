class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @dashboards = policy_scope(Dashboard).order(nome: :asc)
  end

  def edit
    @dashboards = Dashboard.where('user_id = ?', current_user.id)
    if params[:id].nil? || params[:id] == "0"
      @dashboard = @dashboards.first
    else
      @dashboard = @dashboards.find(params[:id])
    end
    authorize(@dashboard)
  end

  def update
    @dashboard = Dashboard.find(params[:id])
    if @dashboard.update(dashboard_params)
      redirect_to dashboard_path(@dashboard.id), notice: 'Nome do Painel alterado com sucesso'
    else
      render :edit
    end
    authorize @dashboard
  end

  def show
    @dashboards = policy_scope(Dashboard).order(nome: :asc)
    if params[:id].nil? || params[:id] == "0"
      @dashboard = @dashboards.first
    else
      @dashboard = @dashboards.find(params[:id])
    end
    authorize(@dashboard)
  end

  def new
    @dashboard = Dashboard.new
    @dashboards = Dashboard.where('user_id = ?', current_user.id)

    authorize @dashboard
  end

  def create
    @dashboard = Dashboard.new(dashboard_params)
    @dashboard.user = current_user

    if @dashboard.save
      indicadores = Indicator.all.sample(5)
      indicadores.each_with_index do |ind, i|
        tipo = ["circular", "circular", "circular", "circular", "linha", "barra"].sample
        Kpi.create!(dashboard_id: @dashboard.id,
                    indicator_id: ind.id,
                    nome: ind.nome[0..49],
                    destaque: tipo != "circular",
                    ordem: i + 1,
                    tipo_grafico: tipo)
      end
      redirect_to dashboard_path(@dashboard.id), notice: 'Dashboard criado com sucesso'
    else
      raise
      @dashboards = Dashboard.where('user_id = ?', current_user.id)
      render :new
    end
    authorize @dashboard
  end

  def destroy
    @dashboard = Dashboard.find(params[:id])
    authorize @dashboard
    @dashboard.destroy
    redirect_to edit_dashboard_path("0"), notice: 'Dashboard excluído com sucesso'
  end

  def dashboard_params
    params.require(:dashboard).permit(:nome)
  end
end
