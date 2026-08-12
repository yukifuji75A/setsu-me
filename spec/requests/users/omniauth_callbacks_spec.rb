require "rails_helper"

RSpec.describe "Users::OmniauthCallbacks", type: :request do
  describe "GET /users/auth/line/callback" do
    context "認証に成功した場合" do
      before do
        OmniAuth.config.mock_auth[:line] = OmniAuth::AuthHash.new(
          provider: "line",
          uid: "12345",
          info: { name: "テストユーザー" }
        )
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:line]
      end

      it "ユーザーが作成され、サインインしてプロフィール登録画面にリダイレクトされること" do
        expect {
          get user_line_omniauth_callback_path
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(new_profile_path)
        expect(User.last.provider).to eq("line")
        expect(User.last.uid).to eq("12345")
      end

      context "既に同じprovider・uidのユーザーが存在し、プロフィール登録済みの場合" do
        before do
          user = create(:user, provider: "line", uid: "12345")
          create(:profile, user: user)
        end

        it "新規ユーザーを作成せずサインインし、mypageにリダイレクトされること" do
          expect {
            get user_line_omniauth_callback_path
          }.not_to change(User, :count)

          expect(response).to redirect_to(mypage_path)
        end
      end
    end

    context "認証に失敗した場合" do
      before do
        OmniAuth.config.mock_auth[:line] = :invalid_credentials
        Rails.application.env_config["omniauth.auth"] = nil
      end

      it "ログイン画面にリダイレクトされること" do
        get user_line_omniauth_callback_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
