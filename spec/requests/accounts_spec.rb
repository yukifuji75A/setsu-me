require "rails_helper"

RSpec.describe "Accounts", type: :request do
  let(:user) { create(:user, email: "old@example.com", password: "old_password", password_confirmation: "old_password") }
  let(:line_user) { create(:user, provider: "line", uid: "12345", email: nil, password: nil) }

  describe "GET /account/edit" do
    context "プロフィール設定済みの通常ユーザーの場合" do
      before do
        create(:profile, user: user)
        sign_in user
      end

      it "200が返ること" do
        get edit_account_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "LINE登録ユーザーの場合" do
      before do
        create(:profile, user: line_user)
        sign_in line_user
      end

      it "mypageへリダイレクトされアラートが表示されること" do
        get edit_account_path
        expect(response).to redirect_to(mypage_path)
      end
    end

    context "未ログインの場合" do
      it "ログイン画面へリダイレクトされること" do
        get edit_account_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /account" do
    before do
      create(:profile, user: user)
      sign_in user
    end

    context "正しい現在のパスワードでメールアドレスのみ変更する場合" do
      it "mypageへリダイレクトされ、メールアドレスが更新されること" do
        patch account_path, params: {
          user: {
            email: "new@example.com",
            current_password: "old_password"
          }
        }

        expect(response).to redirect_to(mypage_path)
        expect(user.reload.email).to eq("new@example.com")
        expect(user.reload.email).not_to eq("old@example.com")
      end
    end

    context "正しい現在のパスワードで新しいパスワードに変更する場合" do
      it "mypageへリダイレクトされ、新しいパスワードでログインできること" do
        patch account_path, params: {
          user: {
            password: "new_password",
            password_confirmation: "new_password",
            current_password: "old_password"
          }
        }

        expect(response).to redirect_to(mypage_path)
        expect(user.reload.valid_password?("new_password")).to eq(true)
      end
    end

    context "入力した現在のパスワードが間違っている場合" do
      it "更新に失敗すること" do
        patch account_path, params: {
          user: {
            email: "old@example.com",
            current_password: "wrong_password"
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "新しいメールアドレスの形式が不正の場合" do
      it "更新に失敗すること" do
        patch account_path, params: {
          user: {
            email: "invalid-format",
            current_password: "old_password"
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "新しいパスワードと確認のパスワードが不一致の場合" do
      it "更新に失敗すること" do
        patch account_path, params: {
          user: {
            email: "old@example.com",
            password: "new_password",
            password_confirmation: "wrong_password",
            current_password: "old_password"
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
