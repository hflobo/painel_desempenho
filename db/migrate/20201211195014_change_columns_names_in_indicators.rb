class ChangeColumnsNamesInIndicators < ActiveRecord::Migration[6.0]
  def change
    rename_column :indicators, :periodo_do_indice, :qtd_apuracoes_ano
    rename_column :indicators, :periodo_da_meta, :qtd_metas_ano
  end
end
