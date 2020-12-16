class KpisController < ApplicationController
  def new
    @kpi = Kpi.new
    @indicator = Indicator.find(params[:indicator_id])
  end

  def create
    @kpi = Kpi.new(kpi_params)
    @indicator = Indicator.find(params[:indicator_id])
    @kpi.indicator = @indicator
    if @kpi.save
      redirect_to indicator_path(@indicator)
    else
      render :new
    end
  end

  private


  def kpi_params
    params.require(:kpi).permit(:content, :rating)
  end

end
end
