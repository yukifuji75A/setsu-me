class CreateManualAiTexts < ActiveRecord::Migration[7.2]
  def change
    create_table :manual_ai_texts do |t|
      t.references :manual, null: false, foreign_key: true
      t.integer :section_type, null: false
      t.text :ai_text, null: false
      t.text :user_edited_text

      t.timestamps
    end
    add_index :manual_ai_texts, [ :manual_id, :section_type ], unique: true
  end
end
