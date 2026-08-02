require "rails_helper"

RSpec.describe ManualAiText, type: :model do
  describe "バリデーション" do
    context "section_typeとai_textが設定されている場合" do
      it "有効であること" do
        manual_ai_text = build(:manual_ai_text)
        expect(manual_ai_text).to be_valid
      end
    end

    context "section_typeが空の場合" do
      it "無効であること" do
        manual_ai_text = build(:manual_ai_text, section_type: nil)
        expect(manual_ai_text).not_to be_valid
      end
    end

    context "ai_textが空の場合" do
      it "無効であること" do
        manual_ai_text = build(:manual_ai_text, ai_text: nil)
        expect(manual_ai_text).not_to be_valid
      end
    end

    context "同じmanual・同じsection_typeの組み合わせがすでに存在する場合" do
      it "無効であること" do
        manual = create(:manual)
        create(:manual_ai_text, manual: manual, section_type: :basic_spec)
        duplicate = build(:manual_ai_text, manual: manual, section_type: :basic_spec)

        expect(duplicate).not_to be_valid
      end
    end
  end
end
