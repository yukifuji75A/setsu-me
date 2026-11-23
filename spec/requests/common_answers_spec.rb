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

      it "回答状況パネルに質問へ移動するQ番号リンクが表示されること" do
        create(:question, theme: :common, answer_type: :text, position: 1)

        get edit_common_answers_path

        html = Nokogiri::HTML(response.body)
        expect(html.at_css("#question-1")).to be_present
        expect(html.text).to include("回答状況")
        expect(html.at_css('a[href="#question-1"]')).to be_present
        expect(html.at_css('a[href="#question-1"]')["data-turbo"]).to eq("false")
      end

      it "テーマがないため、回答状況パネルはdefaultテーマと同じ紫系の色になること" do
        create(:question, theme: :common, answer_type: :text, position: 1)

        get edit_common_answers_path

        html = Nokogiri::HTML(response.body)
        expect(html.at_css('[data-answer-progress-target="bar"]')["class"]).to include("from-accent-purple")
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
