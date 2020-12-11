class ObjectivesController < ApplicationController
   def index
    @objectives = Objective.all
   end
   
   def new
    # we need @objectve in our `simple_form_for`
    @objectve = Objectve.find(params[:objectve_id])
  end

  def create
    @objectve = Objectve.new(objectve_params)
    @objectve.save

    # no need for app/views/objectves/create.html.erb
    # redirect_to objectve_path(@objectve)
  end

  def edit
    @objectve = Objectve.find(params[:objectve_id])
  end

  def update
    @objectve = Objectve.find(params[:objectve_id])
    @objective.update(objectve_params)

  end

  def destroy
    @objective = Objective.find(params[:id])
    @objective.destroy

    # no need for app/views/objectives/destroy.html.erb
    redirect_to objectives_path
  end



  private

  def objectve_params
    params.require(:objectve).permit(:nome)
  end
  
  
end
