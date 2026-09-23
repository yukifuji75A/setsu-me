class RemoveHobbyQuestionFromCommon < ActiveRecord::Migration[8.0]
  def up
    question = Question.unscoped.find_by(theme: :common, position: 3)
    return unless question

    Answer.unscoped.where(question_id: question.id).delete_all
    question.destroy!
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
