require "rails_helper"

RSpec.describe "StaticPages", type: :request do
  # ページ上下の「戻る」リンクのリンク先
  def back_links
    Nokogiri::HTML(response.body).css("a").select { |a| a.text.strip == "戻る" }
  end

  def back_link_hrefs
    back_links.map { |a| a["href"] }
  end

  def back_links_hidden_on_pc?
    back_links.all? { |a| a.parent["class"].split.include?("lg:hidden") }
  end

  shared_examples "戻るリンクの行き先" do |path_name|
    let(:page_path) { send(path_name) }

    context "未ログインで、同じサイト内のページから開いた場合" do
      it "開く前のページへ戻ること" do
        get page_path, headers: { "HTTP_REFERER" => "http://www.example.com#{new_user_session_path}" }

        expect(back_link_hrefs).to eq([ new_user_session_path ] * 2)
      end
    end

    context "未ログインで、URLを直接開いた場合" do
      it "トップページへ戻ること" do
        get page_path

        expect(back_link_hrefs).to eq([ root_path ] * 2)
      end

      it "PC幅でも「戻る」が表示されること" do
        get page_path

        expect(back_links_hidden_on_pc?).to be(false)
      end
    end

    context "未ログインで、外部サイトから開いた場合" do
      it "トップページへ戻ること" do
        get page_path, headers: { "HTTP_REFERER" => "https://other.example.org/" }

        expect(back_link_hrefs).to eq([ root_path ] * 2)
      end
    end

    context "ログイン済みの場合" do
      it "マイページへ戻ること" do
        user = create(:user)
        create(:profile, user: user)
        sign_in user

        get page_path, headers: { "HTTP_REFERER" => "http://www.example.com#{new_user_session_path}" }

        expect(back_link_hrefs).to eq([ mypage_path ] * 2)
      end

      it "PC幅では「戻る」が隠れること（サイドバーから移動できるため）" do
        user = create(:user)
        create(:profile, user: user)
        sign_in user

        get page_path

        expect(back_links_hidden_on_pc?).to be(true)
      end
    end
  end

  it_behaves_like "戻るリンクの行き先", :terms_path
  it_behaves_like "戻るリンクの行き先", :privacy_path

  describe "GET /terms" do
    context "未ログインの場合" do
      it "200が返ること" do
        get terms_path

        expect(response).to have_http_status(:ok)
      end

      it "サイドバーが表示されないこと" do
        get terms_path

        expect(response.body).not_to include('aria-label="メインメニュー"')
      end

      it "トップページへのロゴリンクが表示されること" do
        get terms_path

        expect(Nokogiri::HTML(response.body).at_css('a[aria-label="トップページへ"][href="/"]')).to be_present
      end
    end

    context "ログイン済みの場合" do
      it "200が返ること" do
        user = create(:user)
        create(:profile, user: user)
        sign_in user

        get terms_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('aria-label="メインメニュー"')
      end

      it "トップページへのロゴリンクが表示されないこと" do
        user = create(:user)
        create(:profile, user: user)
        sign_in user

        get terms_path

        expect(Nokogiri::HTML(response.body).at_css('a[aria-label="トップページへ"]')).to be_nil
      end
    end
  end

  describe "GET /privacy" do
    context "未ログインの場合" do
      it "200が返ること" do
        get privacy_path

        expect(response).to have_http_status(:ok)
      end

      it "サイドバーが表示されないこと" do
        get privacy_path

        expect(response.body).not_to include('aria-label="メインメニュー"')
      end

      it "トップページへのロゴリンクが表示されること" do
        get privacy_path

        expect(Nokogiri::HTML(response.body).at_css('a[aria-label="トップページへ"][href="/"]')).to be_present
      end
    end

    context "ログイン済みの場合" do
      it "200が返ること" do
        user = create(:user)
        create(:profile, user: user)
        sign_in user

        get privacy_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('aria-label="メインメニュー"')
      end

      it "トップページへのロゴリンクが表示されないこと" do
        user = create(:user)
        create(:profile, user: user)
        sign_in user

        get privacy_path

        expect(Nokogiri::HTML(response.body).at_css('a[aria-label="トップページへ"]')).to be_nil
      end
    end
  end
end
