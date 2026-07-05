class CreateAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :answers do |t|
      t.bigint :user_id, null: false
      t.bigint :question_id, null:false
      t.bigint :question_option_id
      t.text :body
      t.integer :score

      t.timestamps
    end
    add_index :answers, [ :user_id, :question_id ], unique: true
  end
end
