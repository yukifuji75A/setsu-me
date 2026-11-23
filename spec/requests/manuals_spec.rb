require "rails_helper"

RSpec.describe "Manuals", type: :request do
  let(:user) { create(:user) }

  before do
    create(:profile, user: user)
    sign_in user
  end

  # ブロック内のリクエストで描画されたレイアウトのファイルパスを返す
  def rendered_layouts
    layouts = []
    callback = ->(event) { layouts << event.payload[:identifier] }
    ActiveSupport::Notifications.subscribed(callback, "render_layout.action_view") { yield }
    layouts
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

      it "ステップ表示で「回答入力」が現在のステップになること" do
        get step1_manuals_path(theme: "default")

        indicator = Nokogiri::HTML(response.body).at_css('nav[aria-label="作成ステップ"]')
        expect(indicator.at_css('[aria-current="step"]').text).to include("回答入力")
      end

      it "質問カードに質問番号のidが付くこと" do
        create(:question, theme: :default, answer_type: :text, position: 1)

        get step1_manuals_path(theme: "default")

        expect(Nokogiri::HTML(response.body).at_css("#question-1")).to be_present
      end

      it "回答状況パネルに質問へ移動するQ番号リンクが表示されること" do
        create(:question, theme: :default, answer_type: :text, position: 1)

        get step1_manuals_path(theme: "default")

        html = Nokogiri::HTML(response.body)
        expect(html.text).to include("回答状況")
        expect(html.at_css('a[href="#question-1"]')).to be_present
      end

      it "回答状況パネルのQ番号リンクはTurboを通さないこと（ページの取り直しで入力途中の回答が消えないようにするため）" do
        create(:question, theme: :default, answer_type: :text, position: 1)

        get step1_manuals_path(theme: "default")

        expect(Nokogiri::HTML(response.body).at_css('a[href="#question-1"]')["data-turbo"]).to eq("false")
      end

      it "defaultテーマでは紫系の色で表示されること" do
        create(:question, theme: :default, answer_type: :text, position: 1)

        get step1_manuals_path(theme: "default")

        html = Nokogiri::HTML(response.body)
        expect(html.at_css("#question-1")["class"]).to include("border-violet-500")
        expect(html.at_css('[data-controller~="answer-progress"]')["data-answer-progress-answered-class"]).to include("bg-accent-purple")
      end

      it "friendテーマでは質問カード・ステップ表示・回答状況・ボタンが水色系の色になること" do
        create(:question, theme: :friend, answer_type: :text, position: 1)

        get step1_manuals_path(theme: "friend")

        html = Nokogiri::HTML(response.body)
        expect(html.at_css("#question-1")["class"]).to include("border-sky-400")
        expect(html.at_css("#question-1 textarea")["class"]).to include("focus:border-sky-500")
        expect(html.at_css('nav[aria-label="作成ステップ"] [aria-current="step"]')["class"]).to include("text-sky-500")
        expect(html.at_css('[data-controller~="answer-progress"]')["data-answer-progress-answered-class"]).to include("bg-sky-500")
        expect(html.at_css('[data-answer-progress-target="bar"]')["class"]).to include("from-sky-400")
        expect(html.at_css('input[type="submit"][value="次へ（AI生成へ）"]')["class"]).to include("from-sky-400")
        expect(response.body).not_to include("border-violet-500")
      end

      context "サイドバーの「デフォルト」リンク" do
        it "未発行の場合はstep1へのリンクになること" do
          get step1_manuals_path(theme: "friend")

          sidebar = Nokogiri::HTML(response.body).at_css('nav[aria-label="メインメニュー"]')
          expect(sidebar.at_css("a[href='#{step1_manuals_path(theme: "default")}']").text).to include("デフォルト")
        end

        it "発行済みの場合は閲覧画面へのリンクになること" do
          manual = create(:manual, :published, user: user, theme: :default)

          get step1_manuals_path(theme: "friend")

          sidebar = Nokogiri::HTML(response.body).at_css('nav[aria-label="メインメニュー"]')
          expect(sidebar.at_css("a[href='#{manual_path(manual)}']").text).to include("デフォルト")
          expect(sidebar.at_css("a[href='#{step1_manuals_path(theme: "default")}']")).to be_nil
        end
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

      it "ステップ表示で「AI生成」が現在のステップになること" do
        get step2_manuals_path(theme: "default")

        indicator = Nokogiri::HTML(response.body).at_css('nav[aria-label="作成ステップ"]')
        expect(indicator.at_css('[aria-current="step"]').text).to include("AI生成")
      end

      it "friendテーマではカード・ステップ表示・ボタンが水色系の色になること" do
        get step2_manuals_path(theme: "friend")

        html = Nokogiri::HTML(response.body)
        expect(html.at_css('nav[aria-label="作成ステップ"] [aria-current="step"]')["class"]).to include("text-sky-500")
        expect(html.at_css(%(a[href="#{step3_manuals_path(theme: "friend")}"]))["class"]).to include("from-sky-400")
        expect(response.body).to include("border-sky-400")
        expect(response.body).not_to include("border-violet-500")
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

      it "ステップ表示で「最終確認」が現在のステップになること" do
        get step3_manuals_path(theme: "default")

        indicator = Nokogiri::HTML(response.body).at_css('nav[aria-label="作成ステップ"]')
        expect(indicator.at_css('[aria-current="step"]').text).to include("最終確認")
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

      it "カード・ステップ表示・ボタンが水色系の色になること" do
        get step3_manuals_path(theme: "friend")

        html = Nokogiri::HTML(response.body)
        expect(html.at_css('nav[aria-label="作成ステップ"] [aria-current="step"]')["class"]).to include("text-sky-500")
        expect(html.at_css('input[type="submit"][value="トリセツを発行する"]')["class"]).to include("from-sky-400")
        expect(html.at_xpath('//a[normalize-space()="戻る"]')["class"]).to include("border-sky-500")
        expect(response.body).not_to include("border-violet-500")
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

  describe "GET /manuals/edit" do
    before do
      common_question = create(:question, theme: :common, answer_type: :text)
      create(:answer, :text, user: user, question: common_question)
    end

    it "200が返ること" do
      get edit_manuals_path(theme: "default")

      expect(response).to have_http_status(:ok)
    end

    it "friendテーマでも200が返ること" do
      get edit_manuals_path(theme: "friend")

      expect(response).to have_http_status(:ok)
    end

    it "ステップ表示が出ないこと" do
      get edit_manuals_path(theme: "default")

      expect(Nokogiri::HTML(response.body).at_css('nav[aria-label="作成ステップ"]')).to be_nil
    end

    it "回答状況パネルに質問へ移動するQ番号リンクが表示されること" do
      create(:question, theme: :default, answer_type: :text, position: 1)

      get edit_manuals_path(theme: "default")

      html = Nokogiri::HTML(response.body)
      expect(html.text).to include("回答状況")
      expect(html.at_css('a[href="#question-1"]')).to be_present
    end

    it "friendテーマでは質問カード・回答状況・ボタンが水色系の色になること" do
      create(:question, theme: :friend, answer_type: :text, position: 1)

      get edit_manuals_path(theme: "friend")

      html = Nokogiri::HTML(response.body)
      expect(html.at_css("#question-1")["class"]).to include("border-sky-400")
      expect(html.at_css('[data-controller~="answer-progress"]')["data-answer-progress-answered-class"]).to include("bg-sky-500")
      expect(html.at_css('input[type="submit"][value="保存してマイページへ"]')["class"]).to include("from-sky-400")
      expect(response.body).not_to include("border-violet-500")
    end
  end

  describe "PATCH /manuals/edit" do
    before do
      common_question = create(:question, theme: :common, answer_type: :text)
      create(:answer, :text, user: user, question: common_question)
    end

    let!(:default_question) { create(:question, theme: :default, answer_type: :text) }

    context "全ての質問に回答している場合" do
      it "mypageにリダイレクトされ、回答が更新されること" do
        create(:answer, :text, user: user, question: default_question, body: "編集前の回答")

        patch edit_manuals_path(theme: "default"), params: { answers: { default_question.id.to_s => { body: "編集後の回答" } } }

        expect(response).to redirect_to(mypage_path)
        expect(user.answers.find_by(question: default_question).body).to eq("編集後の回答")
      end
    end

    context "未回答の質問がある場合" do
      it "unprocessable_entityでeditが再描画されること" do
        patch edit_manuals_path(theme: "default"), params: { answers: { default_question.id.to_s => { body: "" } } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("全ての質問に回答してください")
      end

      it "editの通常表示と同じinputレイアウトで再描画されること" do
        layouts = rendered_layouts do
          patch edit_manuals_path(theme: "default"), params: { answers: { default_question.id.to_s => { body: "" } } }
        end

        expect(layouts).to contain_exactly(end_with("layouts/input.html.erb"))
      end
    end

    context "friendテーマで全ての質問に回答している場合" do
      let!(:friend_question) { create(:question, theme: :friend, answer_type: :text) }

      it "mypageにリダイレクトされ、回答が更新されること" do
        create(:answer, :text, user: user, question: friend_question, body: "編集前の友だち回答")

        patch edit_manuals_path(theme: "friend"), params: { answers: { friend_question.id.to_s => { body: "編集後の友だち回答" } } }

        expect(response).to redirect_to(mypage_path)
        expect(user.answers.find_by(question: friend_question).body).to eq("編集後の友だち回答")
      end
    end
  end

  describe "PATCH /manuals/regenerate" do
    let!(:default_question) { create(:question, theme: :default, answer_type: :text) }

    before { create(:manual, :published, user: user, theme: :default) }

    context "未回答の質問がある場合" do
      it "unprocessable_entityで、editの通常表示と同じinputレイアウトで再描画されること" do
        layouts = rendered_layouts do
          patch regenerate_manuals_path(theme: "default"), params: { answers: { default_question.id.to_s => { body: "" } } }
        end

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("全ての質問に回答してください")
        expect(layouts).to contain_exactly(end_with("layouts/input.html.erb"))
      end
    end
  end

  describe "GET /manuals/:id" do
    context "自分のmanualを閲覧する場合" do
      it "200が返ること" do
        manual = create(:manual, :published, user: user, theme: :default)
        create(:manual_ai_text, manual: manual, section_type: :basic_spec)

        get manual_path(manual)

        expect(response).to have_http_status(:ok)
      end

      it "目次に各章へのリンクが表示され、章にリンク先のidが付いていること" do
        manual = create(:manual, :published, user: user, theme: :default)
        create(:manual_ai_text, manual: manual, section_type: :basic_spec)

        get manual_path(manual)

        html = Nokogiri::HTML(response.body)
        expect(html.at_css('nav[aria-label="目次"] a[href="#chapter-1"]').text).to include("製品概要")
        expect(html.at_css("#chapter-5")).to be_present
      end

      it "目次の現在位置ハイライト用に、章と目次リンクがtocコントローラーのターゲットになり、テーマ色が渡されること" do
        manual = create(:manual, :published, user: user, theme: :default)
        create(:manual_ai_text, manual: manual, section_type: :basic_spec)

        get manual_path(manual)

        toc = Nokogiri::HTML(response.body).at_css('[data-controller="toc"]')
        expect(toc["data-toc-active-class"]).to include("text-violet-600")
        expect(toc.css('[data-toc-target="chapter"]').size).to eq(5)
        expect(toc.css('nav[aria-label="目次"] a[data-toc-target="link"][data-action="click->toc#select"][data-turbo="false"]').size).to eq(5)
      end

      it "「編集する」リンクが表示されること" do
        manual = create(:manual, :published, user: user, theme: :default)
        create(:manual_ai_text, manual: manual, section_type: :basic_spec)

        get manual_path(manual)

        link = Nokogiri::HTML(response.body).at_css(%(a[href="#{edit_manuals_path(theme: :default)}"]))
        expect(link.text).to eq("編集する")
      end
    end

    context "friendテーマのmanualを閲覧する場合" do
      it "200が返り、friend専用の章立てが表示されること" do
        manual = create(:manual, :published, user: user, theme: :friend)
        create(:manual_ai_text, manual: manual, section_type: :basic_spec)

        get manual_path(manual)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("人間関係・距離感")
      end

      it "目次のハイライトにfriendテーマの色が渡されること" do
        manual = create(:manual, :published, user: user, theme: :friend)
        create(:manual_ai_text, manual: manual, section_type: :basic_spec)

        get manual_path(manual)

        toc = Nokogiri::HTML(response.body).at_css('[data-controller="toc"]')
        expect(toc["data-toc-active-class"]).to include("text-sky-500")
        expect(toc.css('[data-toc-target="chapter"]').size).to eq(5)
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
