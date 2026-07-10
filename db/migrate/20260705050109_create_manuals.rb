class CreateManuals < ActiveRecord::Migration[7.2]
  def change
    create_table :manuals do |t|
      t.bigint :user_id, null: false
      t.integer :theme, null: false
      t.string :share_token, null: false

      t.timestamps
    end
    add_index :manuals, [ :user_id, :theme ], unique: true
    add_index :manuals, :share_token, unique: true
  end
end
