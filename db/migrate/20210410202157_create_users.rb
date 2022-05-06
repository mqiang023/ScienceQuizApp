class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :status
      t.references :organization, foreign_key: true
      t.boolean :active
      t.string :email
      t.string :phone
      t.string :password_digest
      t.string :username

      t.timestamps
    end
  end
end
