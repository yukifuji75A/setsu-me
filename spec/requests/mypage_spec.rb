require "rails_helper"

RSpec.describe "Mypage", type: :request do
  describe "GET /mypage" do
    context "通常ユーザーの場合" do
      let(:user) { create(:user) }

      before do
        create(:profile, user: user)
        sign_in user
      end

      it "200が返ること" do
        get mypage_path

        expect(response).to have_http_status(:ok)
      end

      it "アカウント設定へのリンクが表示されること" do
        get mypage_path

        expect(response.body).to include(edit_account_path)
      end

      context "トリセツが未作成の場合" do
        it "テーマごとに作るリンクが表示されること" do
          get mypage_path

          expect(response.body).to include(step1_manuals_path(theme: "default"))
          expect(response.body).to include(step1_manuals_path(theme: "friend"))
        end
      end

      context "friendテーマのトリセツのみ作成済みの場合" do
        it "friendは見るリンク、defaultは作るリンクが表示されること" do
          manual = create(:manual, user: user, theme: :friend)

          get mypage_path

          expect(response.body).to include(manual_path(manual))
          expect(response.body).not_to include(step1_manuals_path(theme: "friend"))
          expect(response.body).to include(step1_manuals_path(theme: "default"))
        end
      end
    end

    context "LINE登録ユーザーの場合" do
      let(:line_user) { create(:user, provider: "line", uid: "12345", email: nil, password: nil) }

      before do
        create(:profile, user: line_user)
        sign_in line_user
      end

      it "アカウント設定へのリンクが表示されないこと" do
        get mypage_path

        expect(response.body).not_to include(edit_account_path)
      end
    end
  end
end
