class CreateObjectives < ActiveRecord::Migration[6.0]
  def change
    create_table :objectives do |t|
      t.string :tipo
      t.string :nome
      t.string :descricao

      t.timestamps
    end
  end
end
