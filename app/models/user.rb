class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ========== アソシエーション ==========
  has_one :profile, dependent: :destroy
  has_many :manuals, dependent: :destroy
  has_many :answers, dependent: :destroy
end
