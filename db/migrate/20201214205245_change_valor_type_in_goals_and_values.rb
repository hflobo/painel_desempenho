class ChangeValorTypeInGoalsAndValues < ActiveRecord::Migration[6.0]
  def change
    change_column :values, :valor, :decimal, precision: 3, scale: 2
    change_column :goals, :valor, :decimal, precision: 3, scale: 2
  end
end
