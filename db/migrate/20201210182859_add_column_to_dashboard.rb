class AddColumnToDashboard < ActiveRecord::Migration[6.0]
  def change
    add_column :dashboards, :nome, :string
  end
end
