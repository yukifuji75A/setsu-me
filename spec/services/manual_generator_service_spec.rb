require "rails_helper"

RSpec.describe ManualGeneratorService, type: :service do
  let(:user) { create(:user) }
  let(:openai_client) { instance_double(OpenAI::Client) }
  let(:captured_parameters) { {} }

  before do
    allow(OpenAI::Client).to receive(:new).and_return(openai_client)
    allow(openai_client).to receive(:chat) do |parameters:|
      captured_parameters.merge!(parameters)
      {
        "choices" => [
          { "message" => { "content" => '{"basic_spec":"製品概要の文章","handling_guide":"自己分析レポートの文章"}' } }
        ]
      }
    end
  end

  describe "#call" do
    it "OpenAIのレスポンスをパースしてbasic_specとhandling_guideを返すこと" do
      service = ManualGeneratorService.new(user, "default")

      result = service.call

      expect(result).to eq(basic_spec: "製品概要の文章", handling_guide: "自己分析レポートの文章")
      expect(OpenAI::Client).to have_received(:new)
    end

    it "回答内容がテーマ・positionで絞り込まれ、選択式は選択肢ラベル、記述式は本文がプロンプトに含まれること" do
      common_question = create(:question, theme: :common, position: 1, title: "性格ワード", answer_type: :selection)
      common_option = create(:question_option, question: common_question, label: "穏やか")
      create(:answer, :selection, user: user, question: common_question, question_option: common_option)

      excluded_common_question = create(:question, theme: :common, position: 6, title: "対象外の質問")
      excluded_option = create(:question_option, question: excluded_common_question)
      create(:answer, :selection, user: user, question: excluded_common_question, question_option: excluded_option)

      default_text_question = create(:question, theme: :default, position: 2, title: "落ち着く環境", answer_type: :text)
      create(:answer, :text, user: user, question: default_text_question, body: "静かなカフェ")

      service = ManualGeneratorService.new(user, "default")
      service.call

      user_message = captured_parameters[:messages].find { |m| m[:role] == "user" }[:content]

      expect(user_message).to include("性格ワード：穏やか")
      expect(user_message).to include("落ち着く環境：静かなカフェ")
      expect(user_message).not_to include("対象外の質問")
    end

    it "friendテーマの回答がテーマ・positionで絞り込まれてプロンプトに含まれること" do
      friend_question = create(:question, theme: :friend, position: 14, title: "一人の時間と友だちとの時間", answer_type: :selection)
      friend_option = create(:question_option, question: friend_question, label: "どちらも大事")
      create(:answer, :selection, user: user, question: friend_question, question_option: friend_option)

      excluded_default_question = create(:question, theme: :default, position: 1, title: "対象外の質問")
      excluded_option = create(:question_option, question: excluded_default_question)
      create(:answer, :selection, user: user, question: excluded_default_question, question_option: excluded_option)

      service = ManualGeneratorService.new(user, "friend")
      service.call

      user_message = captured_parameters[:messages].find { |m| m[:role] == "user" }[:content]

      expect(user_message).to include("一人の時間と友だちとの時間：どちらも大事")
      expect(user_message).not_to include("対象外の質問")
    end
  end
end
