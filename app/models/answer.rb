class Answer < ApplicationRecord
  # ========== アソシエーション ==========
  belongs_to :user
  belongs_to :question
  belongs_to :question_option, optional: true

  # ========== バリデーション ==========
  validates :user_id, uniqueness: { scope: :question_id }
  validates :body, presence: true, if: -> { question&.text? }
  validates :question_option_id, presence: true, if: -> { question&.selection? }
end
