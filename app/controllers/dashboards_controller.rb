class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @dashboards = policy_scope(Dashboard).order(nome: :asc)
  end

  def show
    @dashboards = policy_scope(Dashboard).order(nome: :asc)
    if params[:id].nil? || params[:id] == "0"
      @dashboard = @dashboards.first
    else
      @dashboard = @dashboards.find(params[:id])
    end
    if @dashboard.nil?
      @dashboard = Dashboard.new
      @dashboard.user = current_user
      @dashboard.nome = "Exemplo"
      @dashboard.save
      criar_painel
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
      criar_painel
      redirect_to dashboard_path(@dashboard.id), notice: 'Dashboard criado com sucesso'
    else
      @dashboards = Dashboard.where('user_id = ?', current_user.id)
      render :new
    end
    authorize @dashboard
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
 
  def destroy
    @dashboard = Dashboard.find(params[:id])
    authorize @dashboard
    @dashboard.destroy
    redirect_to edit_dashboard_path("0"), notice: 'Dashboard excluído com sucesso'
  end

  private

  def dashboard_params
    params.require(:dashboard).permit(:nome)
  end

  def criar_painel
    indicadores = Indicator.all.sample(6)
    j = 0
    indicadores.each_with_index do |ind, i|
      tipo = ["linha", "circular", "linha", "circular", "barra", "circular"]
      destaque = [true, false, false, false, true, false]
      Kpi.create!(dashboard_id: @dashboard.id,
                  indicator_id: ind.id,
                  nome: ind.nome[0..44],
                  destaque: destaque[j],
                  ordem: j + 1,
                  tipo_grafico: tipo[j])
      j += 1
    end
  end
end
