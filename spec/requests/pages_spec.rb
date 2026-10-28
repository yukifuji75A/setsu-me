require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    context "未ログインの場合" do
      it "200が返ること" do
        get root_path

        expect(response).to have_http_status(:ok)
      end

      it "新規登録とログインへのリンクが表示されること" do
        get root_path

        expect(response.body).to include(new_user_registration_path)
        expect(response.body).to include(new_user_session_path)
      end
    end

    context "ログイン済み（プロフィール作成済み）の場合" do
      it "マイページへリダイレクトされること" do
        user = create(:user)
        create(:profile, user: user)
        sign_in user

        get root_path

        expect(response).to redirect_to(mypage_path)
      end
    end

    context "ログイン済み（プロフィール未作成）の場合" do
      it "マイページへリダイレクトされること" do
        user = create(:user)
        sign_in user

        get root_path

        expect(response).to redirect_to(mypage_path)
      end
    end
  end
end
