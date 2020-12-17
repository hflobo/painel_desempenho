class AddGestorToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :gestor, :boolean, default: false
  end
end
