class CreateValues < ActiveRecord::Migration[6.0]
  def change
    create_table :values do |t|
      t.integer :ano
      t.integer :periodo
      t.integer :valor
      t.references :indicator, null: false, foreign_key: true

      t.timestamps
    end
  end
end
