class AddColumnsProvidenciaToAlerts < ActiveRecord::Migration[6.0]
  def change
    add_column :alerts, :texto_providencia, :string
    add_column :alerts, :providencia, :boolean
  end
end
