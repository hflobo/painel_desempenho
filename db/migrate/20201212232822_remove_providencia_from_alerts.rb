class RemoveProvidenciaFromAlerts < ActiveRecord::Migration[6.0]
  def change
    remove_column :alerts, :providencia, :string
  end
end
