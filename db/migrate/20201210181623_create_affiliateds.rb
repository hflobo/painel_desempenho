class CreateAffiliateds < ActiveRecord::Migration[6.0]
  def change
    create_table :affiliateds do |t|
      t.references :indicator, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
