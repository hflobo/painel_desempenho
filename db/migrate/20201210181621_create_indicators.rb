class CreateIndicators < ActiveRecord::Migration[6.0]
  def change
    create_table :indicators do |t|
      t.string :nome
      t.string :sigla
      t.string :finalidade
      t.string :abrangencia
      t.string :unidade_de_medida
      t.integer :periodo_do_indice
      t.integer :periodo_da_meta
      t.references :user, null: false, foreign_key: true
      t.references :objective, null: false, foreign_key: true
      t.references :region, null: false, foreign_key: true
      t.references :indicator, null: false, foreign_key: true

      t.timestamps
    end
  end
end
