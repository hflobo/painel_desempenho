class AddTipoMetaToIndicators < ActiveRecord::Migration[6.0]
  def change
    add_column :indicators, :tipo_meta_max, :boolean, default: true, null: false
    remove_column :goals, :maximo
  end
end
