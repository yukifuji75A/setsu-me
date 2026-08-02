require "rails_helper"

RSpec.describe Manual, type: :model do
  describe "バリデーション" do
    context "themeが設定されている場合" do
      it "有効であること" do
        manual = build(:manual)
        expect(manual).to be_valid
      end
    end

    context "themeが空の場合" do
      it "無効であること" do
        manual = build(:manual, theme: nil)
        expect(manual).not_to be_valid
      end
    end

    context "同じユーザー・同じthemeの組み合わせがすでに存在する場合" do
      it "無効であること" do
        user = create(:user)
        create(:manual, user: user, theme: :default)
        duplicate = build(:manual, user: user, theme: :default)

        expect(duplicate).not_to be_valid
      end
    end

    context "同じユーザーでもthemeが異なる場合" do
      it "有効であること" do
        user = create(:user)
        create(:manual, user: user, theme: :default)
        other_theme = build(:manual, user: user, theme: :lover)

        expect(other_theme).to be_valid
      end
    end
  end
end
