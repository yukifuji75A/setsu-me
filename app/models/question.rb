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

  # ========== 表示ラベル ==========
  DISPLAY_LABELS = {
    common: {
      1 => "性格ワード",
      2 => "MBTI",
      3 => "趣味",
      4 => "思考タイプ",
      5 => "行動タイプ"
    },
    default: {
      1 => "相性のいいタイプ",
      2 => "落ち着く環境",
      3 => "嬉しい接し方",
      4 => "好きな話題",
      5 => "苦手なタイプ",
      6 => "苦手な環境",
      7 => "苦手な接し方",
      8 => "地雷・NG",
      9 => "状況①",
      10 => "対処法①",
      11 => "状況②",
      12 => "対処法②"
    }
  }.freeze

  def display_label
    DISPLAY_LABELS.dig(theme.to_sym, position) || title
  end
end
