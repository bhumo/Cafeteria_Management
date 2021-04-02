class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :password_digest
      t.string :role, null: false
      t.string :status, null: false

      t.timestamps
    end
  end
end
