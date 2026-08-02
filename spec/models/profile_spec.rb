require "rails_helper"

RSpec.describe Profile, type: :model do
  describe "バリデーション" do
    context "すべての項目が正しく入力されている場合" do
      it "有効であること" do
        profile = build(:profile)
        expect(profile).to be_valid
      end
    end

    context "nameが空の場合" do
      it "無効であること" do
        profile = build(:profile, name: nil)
        expect(profile).not_to be_valid
      end
    end

    context "birthdayが空の場合" do
      it "無効であること" do
        profile = build(:profile, birthday: nil)
        expect(profile).not_to be_valid
      end
    end

    context "hometownが空の場合" do
      it "無効であること" do
        profile = build(:profile, hometown: nil)
        expect(profile).not_to be_valid
      end
    end

    context "educationが空の場合" do
      it "無効であること" do
        profile = build(:profile, education: nil)
        expect(profile).not_to be_valid
      end
    end

    context "blood_typeが空の場合" do
      it "無効であること" do
        profile = build(:profile, blood_type: nil)
        expect(profile).not_to be_valid
      end
    end
  end

  describe "#age" do
    context "birthdayが設定されている場合" do
      it "現在の年齢を計算できること" do
        profile = build(:profile, birthday: 20.years.ago.to_date)
        expect(profile.age).to eq(20)
      end
    end

    context "birthdayがnilの場合" do
      it "nilを返すこと" do
        profile = build(:profile, birthday: nil)
        expect(profile.age).to be_nil
      end
    end
  end

  describe "#zodiac_sign" do
    context "おひつじ座の開始日（3/21）の場合" do
      it "おひつじ座と判定されること" do
        profile = build(:profile, birthday: Date.new(2000, 3, 21))
        expect(profile.zodiac_sign).to eq("おひつじ座")
      end
    end

    context "おひつじ座の前日（3/20）の場合" do
      it "うお座と判定されること" do
        profile = build(:profile, birthday: Date.new(2000, 3, 20))
        expect(profile.zodiac_sign).to eq("うお座")
      end
    end

    context "年をまたぐやぎ座の期間（12/22, 1/19）の場合" do
      it "やぎ座と判定されること" do
        profile_dec = build(:profile, birthday: Date.new(2000, 12, 22))
        profile_jan = build(:profile, birthday: Date.new(2000, 1, 19))
        expect(profile_dec.zodiac_sign).to eq("やぎ座")
        expect(profile_jan.zodiac_sign).to eq("やぎ座")
      end
    end

    context "birthdayがnilの場合" do
      it "nilを返すこと" do
        profile = build(:profile, birthday: nil)
        expect(profile.zodiac_sign).to be_nil
      end
    end
  end
end
