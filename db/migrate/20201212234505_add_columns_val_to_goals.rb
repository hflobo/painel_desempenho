class AddColumnsValToGoals < ActiveRecord::Migration[6.0]
  def change
    add_column :goals, :val_jan, :float
    add_column :goals, :val_fev, :float
    add_column :goals, :val_mar, :float
    add_column :goals, :val_abr, :float
    add_column :goals, :val_mai, :float
    add_column :goals, :val_jun, :float
    add_column :goals, :val_jul, :float
    add_column :goals, :val_ago, :float
    add_column :goals, :val_set, :float
    add_column :goals, :val_out, :float
    add_column :goals, :val_nov, :float
    add_column :goals, :val_dez, :float
  end
end
