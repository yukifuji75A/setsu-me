require "rails_helper"

RSpec.describe "Users::Registrations", type: :request do
  describe "GET /users/sign_up" do
    it "200が返ること" do
      get new_user_registration_path

      expect(response).to have_http_status(:ok)
    end

    it "トップページへのロゴリンクが表示されること" do
      get new_user_registration_path

      expect(Nokogiri::HTML(response.body).at_css('a[aria-label="トップページへ"][href="/"]')).to be_present
    end

    it "カードの外に規約リンクが表示されること" do
      get new_user_registration_path

      legal_links = Nokogiri::HTML(response.body).at_css('nav[aria-label="規約"]')
      expect(legal_links.at_css("a[href='#{terms_path}']")).to be_present
      expect(legal_links.at_css("a[href='#{privacy_path}']")).to be_present
    end
  end
end
