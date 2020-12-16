class DashboardsController < ApplicationController

  def index
    @dashboards = policy_scope(Dashboard).order(nome: :asc)
  end

  def show
    @dashboards = policy_scope(Dashboard).order(nome: :asc)
    if params[:id].nil?
      @dashboard = @dashboards.first
    else
      @dashboard = @dashboards.find(params[:id])
    end
    authorize(@dashboard)
  end


end
