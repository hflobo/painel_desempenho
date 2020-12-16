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
      redirect_to alerts_sent_path, notice: 'Alerta criado com sucesso'
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

  def update
    if params[:alert].nil?
      if @alert.data_ciencia.nil?
        if @alert.update(data_ciencia: Date.today)
          redirect_to alerts_received_path, notice: 'Data de ciência informada com sucesso'
        else
          render :alerts_received
        end
      elsif !@alert.arquivado
        if @alert.update(arquivado: true)
          redirect_to alerts_sent_path, notice: 'Alerta arquivado com sucesso'
        else
          render :alerts_sent
        end
      end
    elsif params[:alert]["texto_providencia"].nil?
      if @alert.update(alert_params)
        redirect_to alerts_sent_path, notice: 'Alerta editado com sucesso'
      else
        render :edit
      end
    else
      @alert.data_providencia = Date.today
      if @alert.update(alert_params)
        redirect_to alerts_received_path, notice: 'Providencia informada com sucesso'
      else
        render :alerts_received
      end
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
