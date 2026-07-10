class CreateQuestionOptions < ActiveRecord::Migration[7.2]
  def change
    create_table :question_options do |t|
      t.references :question, null: false, foreign_key: true
      t.string :label, null: false
      t.integer :position, null: false

      t.timestamps
    end
  end
end
