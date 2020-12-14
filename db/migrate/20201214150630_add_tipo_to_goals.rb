class AddTipoToGoals < ActiveRecord::Migration[6.0]
  def change
    add_column :goals, :maximo, :boolean
  end
end
