class AddNameToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string, limit: 80
  end
end
