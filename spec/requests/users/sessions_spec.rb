require "rails_helper"

RSpec.describe "Users::Sessions", type: :request do
  describe "GET /users/sign_in" do
    it "200が返ること" do
      get new_user_session_path

      expect(response).to have_http_status(:ok)
    end

    it "トップページへのロゴリンクが表示されること" do
      get new_user_session_path

      logo_link = Nokogiri::HTML(response.body).at_css('a[aria-label="トップページへ"][href="/"]')
      expect(logo_link).to be_present
      expect(logo_link.text).to include("トップページへ")
    end

    it "カードの外に規約リンクが表示されること" do
      get new_user_session_path

      legal_links = Nokogiri::HTML(response.body).at_css('nav[aria-label="規約"]')
      expect(legal_links.at_css("a[href='#{terms_path}']")).to be_present
      expect(legal_links.at_css("a[href='#{privacy_path}']")).to be_present
    end

    it "パスワード再設定画面へのリンクが表示されること" do
      get new_user_session_path

      expect(Nokogiri::HTML(response.body).at_css("a[href='#{new_user_password_path}']")).to be_present
    end
  end
end
