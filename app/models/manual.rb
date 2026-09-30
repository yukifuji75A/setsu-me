class Manual < ApplicationRecord
  # ========== 定数 ==========
  MAX_GENERATION_COUNT_BEFORE_PUBLISH = 2
  REGENERATION_INTERVAL = 24.hours

  # ========== アソシエーション ==========
  belongs_to :user
  has_many :manual_ai_texts, dependent: :destroy

  # ========== スコープ ==========
  scope :published, -> { where.not(published_at: nil) }

  # ========== enum ==========
  enum :theme, { default: 0, lover: 1, friend: 2 }

  # ========== バリデーション ==========
  validates :theme, presence: true
  validates :user_id, uniqueness: { scope: :theme }

  # ========== コールバック ==========
  before_create :generate_share_token

  # ========== メソッド ==========
  def published?
    published_at.present?
  end

  def regeneration_available?
    if published?
      last_generated_at.blank? || last_generated_at <= REGENERATION_INTERVAL.ago
    else
      generation_count < MAX_GENERATION_COUNT_BEFORE_PUBLISH
    end
  end

  def next_regeneration_at
    return nil if last_generated_at.blank?

    last_generated_at + REGENERATION_INTERVAL
  end

  def remaining_generation_count
    return nil if published?

    [ MAX_GENERATION_COUNT_BEFORE_PUBLISH - generation_count, 0 ].max
  end

  private

  def generate_share_token
    self.share_token = SecureRandom.urlsafe_base64(32)
  end
end
