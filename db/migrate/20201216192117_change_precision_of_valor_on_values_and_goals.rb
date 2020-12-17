class ChangePrecisionOfValorOnValuesAndGoals < ActiveRecord::Migration[6.0]
  def change
    change_column :values, :valor, :decimal, precision: 10, scale: 2
    change_column :goals, :valor, :decimal, precision: 10, scale: 2
  end
end
