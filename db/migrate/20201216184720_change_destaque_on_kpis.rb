class ChangeDestaqueOnKpis < ActiveRecord::Migration[6.0]
  def change
    remove_column :kpis, :destaque
    add_column :kpis, :destaque, :boolean, default: false, null: false
  end
end
