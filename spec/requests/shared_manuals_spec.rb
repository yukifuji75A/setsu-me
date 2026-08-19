require "rails_helper"

RSpec.describe "SharedManuals", type: :request do
  let(:user) { create(:user) }

  before do
    create(:profile, user: user)
  end

  describe "GET /share/:share_token" do
    context "有効な共有トークンでdefaultテーマのmanualを閲覧する場合" do
      it "200が返り、トリセツの内容が表示されること" do
        manual = create(:manual, user: user, theme: :default)
        create(:manual_ai_text, manual: manual, section_type: :basic_spec, ai_text: "製品概要の文章")

        get shared_manual_path(share_token: manual.share_token)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("製品概要の文章")
      end

      it "「マイページへ」リンクが表示されないこと" do
        manual = create(:manual, user: user, theme: :default)
        create(:manual_ai_text, manual: manual, section_type: :basic_spec)

        get shared_manual_path(share_token: manual.share_token)

        expect(response.body).not_to include("マイページへ")
      end

      it "未ログイン状態でもアクセスできること" do
        manual = create(:manual, user: user, theme: :default)
        create(:manual_ai_text, manual: manual, section_type: :basic_spec)

        get shared_manual_path(share_token: manual.share_token)

        expect(response).to have_http_status(:ok)
      end
    end

    context "有効な共有トークンでfriendテーマのmanualを閲覧する場合" do
      it "200が返り、friend専用の章立てが表示されること" do
        manual = create(:manual, user: user, theme: :friend)
        create(:manual_ai_text, manual: manual, section_type: :basic_spec)

        get shared_manual_path(share_token: manual.share_token)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("人間関係・距離感")
      end
    end

    context "存在しない共有トークンでアクセスした場合" do
      it "404が返ること" do
        get shared_manual_path(share_token: "invalid-token")

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
