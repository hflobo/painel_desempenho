class AddColumnsValToValues < ActiveRecord::Migration[6.0]
  def change
    add_column :values, :val_jan, :float
    add_column :values, :val_fev, :float
    add_column :values, :val_mar, :float
    add_column :values, :val_abr, :float
    add_column :values, :val_mai, :float
    add_column :values, :val_jun, :float
    add_column :values, :val_jul, :float
    add_column :values, :val_ago, :float
    add_column :values, :val_set, :float
    add_column :values, :val_out, :float
    add_column :values, :val_nov, :float
    add_column :values, :val_dez, :float
  end
end
