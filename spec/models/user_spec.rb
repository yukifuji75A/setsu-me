require "rails_helper"

RSpec.describe User, type: :model do
  describe ".from_omniauth" do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: "line",
        uid: "12345",
        info: { name: "テストユーザー" }
      )
    end

    context "該当するprovider・uidのユーザーが存在しない場合" do
      it "新しいユーザーを作成すること" do
        expect { User.from_omniauth(auth) }.to change(User, :count).by(1)
      end

      it "authのprovider・uidが設定されること" do
        user = User.from_omniauth(auth)

        expect(user.provider).to eq("line")
        expect(user.uid).to eq("12345")
      end
    end

    context "該当するprovider・uidのユーザーが既に存在する場合" do
      let!(:existing_user) { create(:user, provider: "line", uid: "12345") }

      it "新しいユーザーを作成せず、既存ユーザーを返すこと" do
        expect { User.from_omniauth(auth) }.not_to change(User, :count)
        expect(User.from_omniauth(auth)).to eq(existing_user)
      end
    end
  end

  describe "#line_user?" do
    context "providerがlineの場合" do
      it "trueを返すこと" do
        user = build(:user, provider: "line", uid: "12345")

        expect(user.line_user?).to eq(true)
      end
    end

    context "providerがlineでない場合" do
      it "falseを返すこと" do
        user = build(:user)

        expect(user.line_user?).to eq(false)
      end
    end
  end

  describe "バリデーション" do
    context "LINEユーザーの場合" do
      it "emailとpasswordが未設定でも有効であること" do
        user = build(:user, provider: "line", uid: "12345", email: nil, password: nil, password_confirmation: nil)

        expect(user).to be_valid
      end
    end

    context "通常ユーザー（メール・パスワード認証）の場合" do
      it "emailが未設定の場合は無効であること" do
        user = build(:user, email: nil)

        expect(user).to be_invalid
        expect(user.errors[:email]).to be_present
      end

      it "passwordが未設定の場合は無効であること" do
        user = build(:user, password: nil, password_confirmation: nil)

        expect(user).to be_invalid
        expect(user.errors[:password]).to be_present
      end
    end
  end
end
