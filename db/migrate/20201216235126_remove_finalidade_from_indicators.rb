class RemoveFinalidadeFromIndicators < ActiveRecord::Migration[6.0]
  def change
    remove_column :indicators, :finalidade, :string
  end
end
