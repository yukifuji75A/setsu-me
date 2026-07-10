class CreateProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles do |t|
      t.bigint :user_id, null: false
      t.string :name, null: false
      t.date :birthday, null: false
      t.integer :hometown, null: false
      t.integer :education, null: false
      t.integer :blood_type, null: false

      t.timestamps
    end

    add_index :profiles, :user_id, unique: true
  end
end
