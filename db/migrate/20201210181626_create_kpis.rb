class CreateKpis < ActiveRecord::Migration[6.0]
  def change
    create_table :kpis do |t|
      t.string :destaque
      t.integer :ordem
      t.string :tipo_grafico
      t.references :indicator, null: false, foreign_key: true
      t.references :dashboard, null: false, foreign_key: true

      t.timestamps
    end
  end
end
