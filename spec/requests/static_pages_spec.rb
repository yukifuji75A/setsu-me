require "rails_helper"

RSpec.describe "StaticPages", type: :request do
  describe "GET /terms" do
    context "未ログインの場合" do
      it "200が返ること" do
        get terms_path

        expect(response).to have_http_status(:ok)
      end
    end

    context "ログイン済みの場合" do
      it "200が返ること" do
        user = create(:user)
        create(:profile, user: user)
        sign_in user

        get terms_path

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /privacy" do
    context "未ログインの場合" do
      it "200が返ること" do
        get privacy_path

        expect(response).to have_http_status(:ok)
      end
    end

    context "ログイン済みの場合" do
      it "200が返ること" do
        user = create(:user)
        create(:profile, user: user)
        sign_in user

        get privacy_path

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
