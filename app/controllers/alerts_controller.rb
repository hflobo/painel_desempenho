class AlertsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_alert, only: %i[edit update show destroy]

  def index
  end

  def show
  end

  def new
    @indicator = Indicator.find(params[:id]) unless params[:id].nil?

    @alert = Alert.new
    @alerts = Alert.where('criador_id = ? AND arquivado = ?', current_user.id, false).includes(:destinatario)

    @indicators = Indicator.all
    @users = User.where("id <> #{current_user.id}")

    authorize @alert
  end

  def create
    @alert = Alert.new(alert_params)
    @alert.criador_id = current_user.id
    @alert.arquivado = false
    if @alert.save
      redirect_to alerts_sent_path, notice: 'Alerta criado com sucesso.'
    else
      @alerts = Alert.where('criador_id = ? AND arquivado = ?', current_user.id, false).includes(:destinatario)
      @indicators = Indicator.all
      @users = User.where("id <> #{current_user.id}")
      render :new
    end
    authorize @alert
  end

  def edit
  end

  def providencia
  end

  def update
    if @alert.update(alert_params)
      if User.find(@alert.criador_id) == current_user
        redirect_to alerts_sent_path, notice: 'Alerta editado com sucesso.'
      else
        redirect_to alerts_received_path, notice: 'Providencia informada com sucesso.'
      end
    else
      render :edit
    end
  end

  def confirm
    @alert.data_ciencia = Date.today
    if @alert.update
      redirect_to alerts_received_path, notice: 'Confirmado recebimento do alerta.'
    else
      render :edit
    end
  end

  def destroy
    @alert.destroy
    redirect_to alerts_sent_path, notice: 'Alerta apagado com sucesso.'
  end

  def alerts_sent
    @alerts = Alert.where('criador_id = ? AND arquivado = ?', current_user.id, false).includes(:destinatario)
    authorize @alerts
  end

  def alerts_received
    @alerts = Alert.where('destinatario_id = ? AND arquivado = ?', current_user.id, false).includes(:criador)
    authorize @alerts
  end

  def alerts_filed
    @alerts = Alert.where('criador_id = ? AND arquivado = ?', current_user.id, true).includes(:destinatario)
    authorize @alerts
  end

  private

  def set_alert
    @alert = Alert.find(params[:id])
    @indicator = Indicator.find(@alert.indicator_id)
    if User.find(@alert.criador_id) == current_user
      @alerts = Alert.where('criador_id = ? AND arquivado = ?', current_user.id, false).includes(:destinatario)
    else
      @alerts = Alert.where('destinatario_id = ? AND arquivado = ?', current_user.id, false).includes(:criador)
    end
    @users = User.where("id <> #{current_user.id}")
    authorize @alert
  end

  def alert_params
    params.require(:alert).permit(:descricao, :criador_id, :destinatario_id, :indicator_id, :texto_providencia, :providencia, :arquivado)
  end
end
