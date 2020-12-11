class AddNomeToKpis < ActiveRecord::Migration[6.0]
  def change
    add_column :kpis, :nome, :string, limit: 50
  end
end
