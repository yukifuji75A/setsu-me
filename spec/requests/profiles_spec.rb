require "rails_helper"

RSpec.describe "Profiles", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /profile/new" do
    it "200が返ること" do
      get new_profile_path

      expect(response).to have_http_status(:ok)
    end

    it "サイドバーが表示されないこと" do
      get new_profile_path

      expect(response.body).not_to include('aria-label="メインメニュー"')
    end

    it "未変更時に送信ボタンを無効にする仕組み（form-dirty）が付かないこと" do
      get new_profile_path

      expect(Nokogiri::HTML(response.body).at_css('[data-controller~="form-dirty"]')).to be_nil
    end

    it "トップページへのロゴリンクが表示されないこと" do
      get new_profile_path

      expect(Nokogiri::HTML(response.body).at_css('a[aria-label="トップページへ"]')).to be_nil
    end
  end

  describe "POST /profile" do
    let(:valid_params) do
      {
        profile: {
          name: "テストユーザー",
          birthday: Date.new(2000, 1, 1),
          hometown: :tokyo,
          education: :university,
          blood_type: :type_a
        }
      }
    end

    context "有効なパラメータの場合" do
      it "common-answersの入力画面にリダイレクトされ、profileが作成されること" do
        post profile_path, params: valid_params

        expect(response).to redirect_to(edit_common_answers_path)
        expect(user.reload.profile).to be_present
      end
    end

    context "無効なパラメータの場合" do
      it "unprocessable_entityでnewが再描画されること" do
        post profile_path, params: { profile: valid_params[:profile].merge(name: "") }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(user.reload.profile).to be_nil
      end
    end
  end

  describe "GET /profile/edit" do
    before { create(:profile, user: user) }

    it "200が返ること" do
      get edit_profile_path

      expect(response).to have_http_status(:ok)
    end

    it "サイドバーが表示されること" do
      get edit_profile_path

      expect(response.body).to include('aria-label="メインメニュー"')
    end

    it "更新ボタンが未変更時に無効になるよう form-dirty の対象になっていること" do
      get edit_profile_path

      html = Nokogiri::HTML(response.body)
      expect(html.at_css('form[data-controller~="form-dirty"]')).to be_present
      expect(html.at_css('input[type="submit"][data-form-dirty-target="submit"]')).to be_present
    end
  end

  describe "PATCH /profile" do
    before { create(:profile, user: user, name: "元の名前") }

    context "有効なパラメータの場合" do
      it "mypageにリダイレクトされ、profileが更新されること" do
        patch profile_path, params: { profile: { name: "更新後の名前" } }

        expect(response).to redirect_to(mypage_path)
        expect(user.reload.profile.name).to eq("更新後の名前")
      end
    end

    context "無効なパラメータの場合" do
      it "unprocessable_entityでeditが再描画されること" do
        patch profile_path, params: { profile: { name: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(user.reload.profile.name).to eq("元の名前")
      end
    end
  end
end
