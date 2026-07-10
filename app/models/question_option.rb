class QuestionOption < ApplicationRecord
  # ========== アソシエーション ==========
  belongs_to :question
  has_many :answers

  # ========== バリデーション ==========
  validates :label, presence: true
  validates :position, presence: true
end
