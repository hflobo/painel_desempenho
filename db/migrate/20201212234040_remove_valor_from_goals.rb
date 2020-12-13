class RemoveValorFromGoals < ActiveRecord::Migration[6.0]
  def change
    remove_column :goals, :valor, :integer
  end
end
