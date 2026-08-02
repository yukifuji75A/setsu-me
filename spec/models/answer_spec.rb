require "rails_helper"

RSpec.describe Answer, type: :model do
  describe "バリデーション" do
    context "同じユーザー・同じ質問の組み合わせがすでに存在する場合" do
      it "無効であること" do
        user = create(:user)
        question = create(:question)
        create(:answer, :selection, user: user, question: question)
        duplicate = build(:answer, :selection, user: user, question: question)

        expect(duplicate).not_to be_valid
      end
    end

    context "選択式の質問の場合" do
      it "question_option_idがあれば有効であること" do
        answer = create(:answer, :selection)
        expect(answer).to be_valid
      end

      it "question_option_idが空の場合は無効であること" do
        question = create(:question)
        answer = build(:answer, question: question, question_option: nil, body: nil)

        expect(answer).not_to be_valid
      end
    end

    context "記述式の質問の場合" do
      it "bodyがあれば有効であること" do
        answer = build(:answer, :text)
        expect(answer).to be_valid
      end

      it "bodyが空の場合は無効であること" do
        question = create(:question, answer_type: :text)
        answer = build(:answer, question: question, body: nil, question_option: nil)

        expect(answer).not_to be_valid
      end
    end
  end

  describe ".for_theme" do
    context "themeを指定した場合" do
      it "指定したthemeの質問に対する回答のみ取得できること" do
        user = create(:user)
        default_question = create(:question, theme: :default)
        lover_question = create(:question, theme: :lover)
        default_answer = create(:answer, :selection, user: user, question: default_question)
        create(:answer, :selection, user: user, question: lover_question)

        result = Answer.for_theme(:default)

        expect(result).to contain_exactly(default_answer)
      end
    end
  end
end
