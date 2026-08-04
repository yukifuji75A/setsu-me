require "rails_helper"

RSpec.describe "Manuals", type: :request do
  let(:user) { create(:user) }

  before do
    create(:profile, user: user)
    sign_in user
  end

  describe "GET /manuals/step1" do
    context "共通情報が未入力の場合" do
      it "common-answersの入力画面にリダイレクトされること" do
        get step1_manuals_path

        expect(response).to redirect_to(edit_common_answers_path)
      end
    end

    context "共通情報が入力済みの場合" do
      before do
        common_question = create(:question, theme: :common, answer_type: :text)
        create(:answer, :text, user: user, question: common_question)
      end

      it "200が返ること" do
        get step1_manuals_path

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST /manuals/step1" do
    before do
      common_question = create(:question, theme: :common, answer_type: :text)
      create(:answer, :text, user: user, question: common_question)
    end

    let!(:default_question) { create(:question, theme: :default, answer_type: :text) }

    context "全ての質問に回答している場合" do
      it "step2にリダイレクトされ、回答が保存されること" do
        post step1_manuals_path, params: { answers: { default_question.id.to_s => { body: "テスト回答" } } }

        expect(response).to redirect_to(step2_manuals_path)
        expect(user.answers.find_by(question: default_question).body).to eq("テスト回答")
      end
    end

    context "未回答の質問がある場合" do
      it "unprocessable_entityでstep1が再描画されること" do
        post step1_manuals_path, params: { answers: { default_question.id.to_s => { body: "" } } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("全ての質問に回答してください")
      end
    end
  end
end
