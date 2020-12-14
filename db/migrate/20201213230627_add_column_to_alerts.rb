class AddColumnToAlerts < ActiveRecord::Migration[6.0]
  def change
    add_column :alerts, :arquivado, :boolean
  end
end
