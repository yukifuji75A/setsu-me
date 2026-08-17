require "rails_helper"

RSpec.describe AnswerSaveService, type: :service do
  let(:user) { create(:user) }

  describe "#call" do
    context "選択式の質問に回答する場合" do
      it "question_option_idが保存されること" do
        question = create(:question, answer_type: :selection)
        question_option = create(:question_option, question: question)
        answer_params = { question.id.to_s => { question_option_id: question_option.id.to_s } }

        service = AnswerSaveService.new(user, [ question ], answer_params)
        result = service.call

        expect(result).to eq(true)
        answer = user.answers.find_by(question: question)
        expect(answer.question_option_id).to eq(question_option.id)
      end
    end

    context "記述式の質問に回答する場合" do
      it "bodyが保存されること" do
        question = create(:question, answer_type: :text)
        answer_params = { question.id.to_s => { body: "テスト回答" } }

        service = AnswerSaveService.new(user, [ question ], answer_params)
        result = service.call

        expect(result).to eq(true)
        answer = user.answers.find_by(question: question)
        expect(answer.body).to eq("テスト回答")
      end
    end

    context "すでに回答が存在する質問に再度回答する場合" do
      it "回答内容が上書きされること" do
        question = create(:question, answer_type: :text)
        create(:answer, :text, user: user, question: question, body: "元の回答")
        answer_params = { question.id.to_s => { body: "更新後の回答" } }

        service = AnswerSaveService.new(user, [ question ], answer_params)
        service.call

        answer = user.answers.find_by(question: question)
        expect(answer.body).to eq("更新後の回答")
      end
    end

    context "選択式の質問でquestion_option_idが空の場合" do
      it "falseを返し、回答が保存されないこと" do
        question = create(:question, answer_type: :selection)
        answer_params = { question.id.to_s => { question_option_id: nil } }

        service = AnswerSaveService.new(user, [ question ], answer_params)
        result = service.call

        expect(result).to eq(false)
        expect(user.answers.find_by(question: question)).to be_nil
      end
    end
  end
end
