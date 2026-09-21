module MypageHelper
  COMMON_TAG_STYLES = {
    "MBTI" => "text-[#4ade80] bg-[rgba(74,222,128,0.14)] border-[rgba(74,222,128,0.3)] font-semibold",
    "性格ワード" => "text-[#c084fc] bg-[rgba(192,132,252,0.14)] border-[rgba(192,132,252,0.3)] font-semibold",
    "趣味" => "text-[#38bdf8] bg-[rgba(56,189,248,0.14)] border-[rgba(56,189,248,0.3)] font-semibold",
    "思考タイプ" => "text-[#f472b6] bg-[rgba(244,114,182,0.14)] border-[rgba(244,114,182,0.3)] font-semibold",
    "行動タイプ" => "text-[#fbbf24] bg-[rgba(251,191,36,0.14)] border-[rgba(251,191,36,0.3)] font-semibold"
  }.freeze

  PROFILE_TAG_STYLE = "text-white bg-slate-400/10 border-slate-400/25".freeze

  def common_tag_style(label)
    COMMON_TAG_STYLES.fetch(label, PROFILE_TAG_STYLE)
  end

  def profile_tag_style
    PROFILE_TAG_STYLE
  end

  THEME_CARD_STYLES = {
    "default" => {
      label: "デフォルト",
      title: "取扱説明書",
      subtext: "新しい出会いに",
      border_gradient: "linear-gradient(135deg, #9333ea, #c026d3)",
      glow_shadow: "0 0 18px -4px rgba(168,85,247,0.4), 0 0 28px -6px rgba(192,38,211,0.3)",
      title_gradient: "linear-gradient(135deg, #c084fc, #e879f9)",
      icon: :document
    },
    "friend" => {
      label: "友だち",
      title: "トリセツ",
      subtext: "親しい友人に",
      border_gradient: "linear-gradient(135deg, #2563eb, #22d3ee)",
      glow_shadow: "0 0 18px -4px rgba(56,189,248,0.4), 0 0 28px -6px rgba(34,211,238,0.3)",
      title_gradient: "linear-gradient(135deg, #38bdf8, #22d3ee)",
      icon: :friends
    }
  }.freeze

  def theme_card_style(theme)
    THEME_CARD_STYLES.fetch(theme)
  end
end
