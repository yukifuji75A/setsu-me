class ManualAiText < ApplicationRecord
  # ========== アソシエーション ==========
  belongs_to :manual

  # ========== enum ==========
  enum :section_type, { basic_spec: 0, handling_guide: 1 }

  # ========== バリデーション ==========
  validates :section_type, presence: true
  validates :ai_text, presence: true
  validates :manual_id, uniqueness: { scope: :section_type }

  # ========== メソッド ==========
  def diplay_text
    user_edited_text.presence || ai_text
  end
end
