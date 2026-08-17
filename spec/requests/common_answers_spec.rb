require "rails_helper"

RSpec.describe "CommonAnswers", type: :request do
  let(:user) { create(:user) }

  describe "GET /common-answers/edit" do
    context "未ログインの場合" do
      it "ログイン画面にリダイレクトされること" do
        get edit_common_answers_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みの場合" do
      before { sign_in user }

      it "200が返ること" do
        get edit_common_answers_path

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PATCH /common-answers" do
    before { sign_in user }

    let!(:question) { create(:question, theme: :common, answer_type: :text) }

    context "全ての質問に回答している場合" do
      it "mypageにリダイレクトされ、回答が保存されること" do
        patch common_answers_path, params: { answers: { question.id.to_s => { body: "テスト回答" } } }

        expect(response).to redirect_to(mypage_path)
        expect(user.answers.find_by(question: question).body).to eq("テスト回答")
      end
    end

    context "未回答の質問がある場合" do
      it "unprocessable_entityでeditが再描画されること" do
        patch common_answers_path, params: { answers: { question.id.to_s => { body: "" } } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("全ての質問に回答してください")
      end
    end
  end
end
