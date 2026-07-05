class Profile < ApplicationRecord
  # ========== リレーション ==========
  belongs_to :user

  enum :hometown, {
    hokkaido: 0, aomori: 1, iwate: 2, miyagi: 3, akita: 4,
    yamagata: 5, fukushima: 6, ibaraki: 7, tochigi: 8, gunma: 9,
    saitama: 10, chiba: 11, tokyo: 12, kanagawa: 13, niigata: 14,
    toyama: 15, ishikawa: 16, fukui: 17, yamanashi: 18, nagano: 19,
    gifu: 20, shizuoka: 21, aichi: 22, mie: 23, shiga: 24,
    kyoto: 25, osaka: 26, hyogo: 27, nara: 28, wakayama: 29,
    tottori: 30, shimane: 31, okayama: 32, hiroshima: 33, yamaguchi: 34,
    tokushima: 35, kagawa: 36, ehime: 37, kochi: 38, fukuoka: 39,
    saga: 40, nagasaki: 41, kumamoto: 42, oita: 43, miyazaki: 44,
    kagoshima: 45, okinawa: 46
  }

  # ========== enum ==========
  enum :education, {
    junior_high: 0, high_school: 1, vocational: 2,
    junior_college: 3, university: 4, graduate: 5, other: 6
  }

  enum :blood_type, { type_a: 0, type_b: 1, type_o: 2, type_ab: 3 }

  # ========== バリデーション ==========
  validates :name, presence: true
  validates :birthday, presence: true
  validates :hometown, presence: true
  validates :education, presence: true
  validates :blood_type, presence: true

  # ========== メソッド ==========
  def age
    return nil unless birthday
    ((Date.today - birthday) / 365.25).to_i
  end

  def zodiac_sign
    return nil unless birthday
    month, day = birthday.month, birthday.day
    case
    when (month == 3 && day >= 21) || (month == 4 && day <= 19) then "おひつじ座"
    when (month == 4 && day >= 20) || (month == 5 && day <= 20) then "おうし座"
    when (month == 5 && day >= 21) || (month == 6 && day <= 21) then "ふたご座"
    when (month == 6 && day >= 22) || (month == 7 && day <= 22) then "かに座"
    when (month == 7 && day >= 23) || (month == 8 && day <= 22) then "しし座"
    when (month == 8 && day >= 23) || (month == 9 && day <= 22) then "おとめ座"
    when (month == 9 && day >= 23) || (month == 10 && day <= 23) then "てんびん座"
    when (month == 10 && day >= 24) || (month == 11 && day <= 22) then "さそり座"
    when (month == 11 && day >= 23) || (month == 12 && day <= 21) then "いて座"
    when (month == 12 && day >= 22) || (month == 1 && day <= 19) then "やぎ座"
    when (month == 1 && day >= 20) || (month == 2 && day <= 18) then "みずがめ座"
    else "うお座"
    end
  end
end
