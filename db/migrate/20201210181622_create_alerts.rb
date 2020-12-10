class CreateAlerts < ActiveRecord::Migration[6.0]
  def change
    create_table :alerts do |t|
      t.string :descricao
      t.date :data_ciencia
      t.string :providencia
      t.date :data_providencia
      t.integer :criador_id
      t.integer :destinatario_id
      t.references :indicator, null: false, foreign_key: true

      t.timestamps
    end
  end
end
