class RegionsController < ApplicationController
  def new
    # we need @region in our `simple_form_for`
    @region = Region.find(params[:region_id])
  end

  def create
    @region = Region.new(region_params)
    @region.save

    # no need for app/views/regions/create.html.erb
    # redirect_to region_path(@region)
  end

  private

  def region_params
    params.require(:region).permit(:nome)
  end
  
end
