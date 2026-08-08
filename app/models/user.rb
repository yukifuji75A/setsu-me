class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :omniauthable, omniauth_providers: [ :line ]

  # ========== バリデーション ==========
  # Devise :validatable 相当のバリデーションを、LINEユーザーには適用しない形で手動定義
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: Devise.email_regexp },
                     unless: :line_user?
  validates :password, presence: true, confirmation: true, length: { within: Devise.password_length },
                        if: -> { !line_user? && (new_record? || password.present?) }

  # ========== アソシエーション ==========
  has_one :profile, dependent: :destroy
  has_many :manuals, dependent: :destroy
  has_many :answers, dependent: :destroy

  # ========== クラスメソッド ==========
  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid)
  end

  # ========== インスタンスメソッド ==========
  def line_user?
    provider == "line"
  end
end
