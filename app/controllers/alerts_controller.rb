class AlertsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_indicator, only: %i[new create]
  before_action :set_alert, only: %i[edit update show destroy]

  def index
  end

  def show
  end

  def new
    @alert = Alert.new
    @alert.indicator = @indicator

    authorize @alert
  end

  def create
  end

  def edit
  end

  def update
    if @alert.update(alert_params)
      redirect_to alerts_sent_path, notice: 'Alerta editado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @alert.destroy
    redirect_to alerts_sent_path, notice: 'Alerta apagado com sucesso.'
  end

  def alerts_sent
    @alerts = Alert.where('criador_id = ?', current_user.id)
    authorize @alerts
  end

  private

  def set_indicator
    @indicator = Indicator.find(params[:id])
  end

  def set_alert
    @alert = Alert.find(params[:id])
    @indicator = Indicator.find(@alert.indicator_id)
    @alerts = Alert.where('criador_id = ?', current_user.id)
    @users = User.all
    authorize @alert
  end

  def alert_params
    params.require(:alert).permit(:descricao, :destinatario_id, :providencia)
  end
end
