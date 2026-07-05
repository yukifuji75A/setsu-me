class Manual < ApplicationRecord
  # ========== リレーション ==========
  belongs_to :user
  has_many :manual_ai_texts, dependent: :destroy

  # ========== enum ==========
  enum :theme, { default: 0, lover: 1, friend: 2 }

  # ========== バリデーション ==========
  validates :theme, presence: true
  validates :user_id, uniqueness: { scope: :theme }

  # ========== コールバック ==========
  before_create :generate_share_token

  private

  def generate_share_token
    self.share_token = SecureRandom.urlsafe_base64(32)
  end
end
