class CreateQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :questions do |t|
      t.integer :theme, null: false
      t.string :title, null: false
      t.integer :answer_type, null: false
      t.integer :position, null: false

      t.timestamps
    end
  end
end
