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
        get step1_manuals_path(theme: "default")

        expect(response).to redirect_to(edit_common_answers_path)
      end
    end

    context "共通情報が入力済みの場合" do
      before do
        common_question = create(:question, theme: :common, answer_type: :text)
        create(:answer, :text, user: user, question: common_question)
      end

      it "200が返ること" do
        get step1_manuals_path(theme: "default")

        expect(response).to have_http_status(:ok)
      end

      it "friendテーマでも200が返ること" do
        get step1_manuals_path(theme: "friend")

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
        post step1_manuals_path(theme: "default"), params: { answers: { default_question.id.to_s => { body: "テスト回答" } } }

        expect(response).to redirect_to(step2_manuals_path(theme: "default"))
        expect(user.answers.find_by(question: default_question).body).to eq("テスト回答")
      end
    end

    context "未回答の質問がある場合" do
      it "unprocessable_entityでstep1が再描画されること" do
        post step1_manuals_path(theme: "default"), params: { answers: { default_question.id.to_s => { body: "" } } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("全ての質問に回答してください")
      end
    end

    context "friendテーマで全ての質問に回答している場合" do
      let!(:friend_question) { create(:question, theme: :friend, answer_type: :text) }

      it "step2にリダイレクトされ、回答が保存されること" do
        post step1_manuals_path(theme: "friend"), params: { answers: { friend_question.id.to_s => { body: "友だちのテスト回答" } } }

        expect(response).to redirect_to(step2_manuals_path(theme: "friend"))
        expect(user.answers.find_by(question: friend_question).body).to eq("友だちのテスト回答")
      end
    end
  end

  describe "GET /manuals/step2" do
    let(:generated_result) { { basic_spec: "製品概要の文章", handling_guide: "自己分析レポートの文章" } }

    context "AI生成が成功する場合" do
      before do
        generator = instance_double(ManualGeneratorService)
        allow(generator).to receive(:call).and_return(generated_result)
        allow(ManualGeneratorService).to receive(:new).and_return(generator)
      end

      it "manualとmanual_ai_textsが作成され、200が返ること" do
        get step2_manuals_path(theme: "default")

        expect(response).to have_http_status(:ok)
        manual = user.manuals.find_by(theme: :default)
        expect(manual.manual_ai_texts.find_by(section_type: :basic_spec).ai_text).to eq("製品概要の文章")
      end

      it "friendテーマでもmanualとmanual_ai_textsが作成され、200が返ること" do
        get step2_manuals_path(theme: "friend")

        expect(response).to have_http_status(:ok)
        manual = user.manuals.find_by(theme: :friend)
        expect(manual.manual_ai_texts.find_by(section_type: :basic_spec).ai_text).to eq("製品概要の文章")
      end
    end

    context "AI生成が失敗する場合" do
      before do
        generator = instance_double(ManualGeneratorService)
        allow(generator).to receive(:call).and_raise(StandardError)
        allow(ManualGeneratorService).to receive(:new).and_return(generator)
      end

      it "step1にリダイレクトされること" do
        get step2_manuals_path(theme: "default")

        expect(response).to redirect_to(step1_manuals_path(theme: "default"))
      end
    end
  end

  describe "GET /manuals/step3" do
    context "manualが存在する場合" do
      before do
        manual = create(:manual, user: user, theme: :default)
        create(:manual_ai_text, manual: manual, section_type: :basic_spec)
        create(:manual_ai_text, manual: manual, section_type: :handling_guide)
      end

      it "200が返ること" do
        get step3_manuals_path(theme: "default")

        expect(response).to have_http_status(:ok)
      end
    end

    context "friendテーマでmanualが存在する場合" do
      before do
        manual = create(:manual, user: user, theme: :friend)
        create(:manual_ai_text, manual: manual, section_type: :basic_spec)
        create(:manual_ai_text, manual: manual, section_type: :handling_guide)
      end

      it "200が返ること" do
        get step3_manuals_path(theme: "friend")

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST /manuals/step3" do
    context "manualが存在する場合" do
      it "manualの詳細ページにリダイレクトされること" do
        manual = create(:manual, user: user, theme: :default)

        post step3_manuals_path(theme: "default")

        expect(response).to redirect_to(manual_path(manual))
      end
    end

    context "manualが存在しない場合" do
      it "step1にリダイレクトされること" do
        post step3_manuals_path(theme: "default")

        expect(response).to redirect_to(step1_manuals_path(theme: "default"))
      end
    end
  end

  describe "GET /manuals/:id" do
    context "自分のmanualを閲覧する場合" do
      it "200が返ること" do
        manual = create(:manual, user: user, theme: :default)
        create(:manual_ai_text, manual: manual, section_type: :basic_spec)

        get manual_path(manual)

        expect(response).to have_http_status(:ok)
      end
    end

    context "friendテーマのmanualを閲覧する場合" do
      it "200が返り、friend専用の章立てが表示されること" do
        manual = create(:manual, user: user, theme: :friend)
        create(:manual_ai_text, manual: manual, section_type: :basic_spec)

        get manual_path(manual)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("人間関係・距離感")
      end
    end

    context "他人のmanualを閲覧しようとした場合" do
      it "404が返ること" do
        other_user = create(:user)
        create(:profile, user: other_user)
        other_manual = create(:manual, user: other_user, theme: :default)

        get manual_path(other_manual)

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
