class ShortenValueQuestionOptionLabels < ActiveRecord::Migration[8.0]
  LABEL_MAP = {
    "成長・挑戦を大事にする" => "成長・挑戦",
    "安定・安心を大事にする" => "安定・安心",
    "自由・自分らしさを大事にする" => "自由・自分らしさ",
    "人とのつながりを大事にする" => "人との繋がり",
    "誠実・信頼を大事にする" => "誠実・信頼",
    "結果・成果を大事にする" => "結果・成果",
    "楽しさ・面白さを大事にする" => "楽しさ・面白さ",
    "調和・協調を大事にする" => "調和・協調"
  }.freeze

  def up
    question = Question.unscoped.find_by(theme: :common, position: 6)
    return unless question

    LABEL_MAP.each do |old_label, new_label|
      QuestionOption.unscoped.where(question_id: question.id, label: old_label).update_all(label: new_label)
    end
  end

  def down
    question = Question.unscoped.find_by(theme: :common, position: 6)
    return unless question

    LABEL_MAP.each do |old_label, new_label|
      QuestionOption.unscoped.where(question_id: question.id, label: new_label).update_all(label: old_label)
    end
  end
end
