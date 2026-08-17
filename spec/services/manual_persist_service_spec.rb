require "rails_helper"

RSpec.describe ManualPersistService, type: :service do
  let(:user) { create(:user) }
  let(:result) { { basic_spec: "製品概要の文章", handling_guide: "自己分析レポートの文章" } }

  describe "#call" do
    context "まだmanualが存在しない場合" do
      it "manualとmanual_ai_textsが新規作成されること" do
        service = ManualPersistService.new(user)

        expect { service.call(:default, result) }.to change { user.manuals.count }.by(1)

        manual = user.manuals.find_by(theme: :default)
        basic_spec = manual.manual_ai_texts.find_by(section_type: :basic_spec)
        handling_guide = manual.manual_ai_texts.find_by(section_type: :handling_guide)

        expect(basic_spec.ai_text).to eq("製品概要の文章")
        expect(handling_guide.ai_text).to eq("自己分析レポートの文章")
      end
    end

    context "すでにmanualが存在する場合" do
      it "manualを新規作成せず、manual_ai_textsの内容が更新されること" do
        manual = create(:manual, user: user, theme: :default)
        create(:manual_ai_text, manual: manual, section_type: :basic_spec, ai_text: "古い製品概要")
        create(:manual_ai_text, manual: manual, section_type: :handling_guide, ai_text: "古い自己分析レポート")

        service = ManualPersistService.new(user)

        expect { service.call(:default, result) }.not_to change { user.manuals.count }

        manual.reload
        basic_spec = manual.manual_ai_texts.find_by(section_type: :basic_spec)
        handling_guide = manual.manual_ai_texts.find_by(section_type: :handling_guide)

        expect(basic_spec.ai_text).to eq("製品概要の文章")
        expect(handling_guide.ai_text).to eq("自己分析レポートの文章")
      end
    end
  end
end
