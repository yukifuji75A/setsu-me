class Question < ApplicationRecord
  # ========== アソシエーション ==========
  has_many :question_options, -> { order(:position) }, dependent: :destroy
  has_many :answers

  # ========== enum ==========
  enum :theme, { common: 0, default: 1, lover: 2, friend: 3 }
  enum :answer_type, { selection: 0, text: 1, score: 2 }

  # ========== バリデーション ==========
  validates :theme, presence: true
  validates :title, presence: true
  validates :answer_type, presence: true
  validates :position, presence: true

  # ========== スコープ ==========
  scope :for_manual, ->(theme) {
    where(theme: [ :common, theme ])
  }
end
