class QuestionOption < ApplicationRecord
  # ========== リレーション ==========
  belongs_to :question
  has_many :answers

  # ========== バリデーション ==========
  validates :label, presence: true
  validates :position, presence: true
end
