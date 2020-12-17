class AddValorMaximoToIndicators < ActiveRecord::Migration[6.0]
  def change
    add_column :indicators, :valor_maximo, :integer, default: 1, null: false
  end
end
