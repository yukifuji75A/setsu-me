module MypageHelper
  THEME_CARD_STYLES = {
    "default" => {
      label: "デフォルト",
      description: "基本的なトリセツ",
      gradient: "from-accent-purple to-accent-pink",
      border: "border-violet-500",
      text: "text-accent-purple"
    },
    "friend" => {
      label: "友だち",
      description: "友だち用トリセツ",
      gradient: "from-sky-400 to-blue-500",
      border: "border-sky-400",
      text: "text-sky-400"
    }
  }.freeze

  def theme_card_style(theme)
    THEME_CARD_STYLES.fetch(theme)
  end
end
