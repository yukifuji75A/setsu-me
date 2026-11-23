require "rails_helper"

RSpec.describe "Users::Passwords", type: :request do
  describe "GET /users/password/new" do
    it "200が返ること" do
      get new_user_password_path

      expect(response).to have_http_status(:ok)
    end

    it "トップページへのロゴリンクとログインへ戻るリンクが表示されること" do
      get new_user_password_path

      html = Nokogiri::HTML(response.body)
      expect(html.at_css('a[aria-label="トップページへ"][href="/"]')).to be_present
      expect(html.at_css("a[href='#{new_user_session_path}']")).to be_present
    end
  end

  describe "GET /users/password/edit" do
    it "再設定用のトークンがあれば200が返ること" do
      token = create(:user).send_reset_password_instructions

      get edit_user_password_path(reset_password_token: token)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("パスワードの変更")
    end
  end
end
