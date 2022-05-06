class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.date :date
      t.integer :organization_id
      t.boolean :active
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
