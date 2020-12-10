class AddForeignKeysAlertsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :alerts, :users, column: "criador_id"
    add_foreign_key :alerts, :users, column: "destinatario_id"
  end
end
