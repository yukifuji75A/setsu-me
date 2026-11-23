module ManualsHelper
  ANSWER_PLACEHOLDERS = {
    "default" => {
      2 => "例：静かな場所、少人数の空間、自分のペースで動ける環境",
      4 => "例：音楽、旅行、最近ハマってること",
      6 => "例：大勢の場、騒がしい環境、予定が詰まっているとき",
      8 => "例：約束を破られること、無視されること、急に予定を変えられること",
      10 => "例：そっとしておいてほしい、話を聞いてほしい",
      12 => "例：気軽に声をかけてほしい、一緒にいてほしい"
    },
    "friend" => {
      15 => "例：とりあえず話を聞いてほしい、アドバイスがほしい、一緒に考えてほしいなど",
      16 => "例：まず相手の意見を聞く、話し合う、いったん距離を置くなど",
      17 => "例：信頼できること、無理せず付き合えること、一緒にいて楽しいことなど",
      18 => "例：よく話すようになる、ふざけるようになる、素が出るなど"
    }
  }.freeze

  def answer_placeholder(theme, question)
    ANSWER_PLACEHOLDERS.dig(theme, question.position) || "入力してください"
  end

  # 閲覧画面の章見出しと目次で共通して使う
  MANUAL_CHAPTER_TITLES = {
    "default" => %w[製品概要 製品仕様 推奨事項 非推奨・禁止事項 トラブル対処],
    "friend" => %w[こんな人です プロフィール 人間関係・距離感 好きなもの・一緒に楽しめること 友だちとの付き合い方]
  }.freeze

  def manual_chapter_titles(theme)
    MANUAL_CHAPTER_TITLES.fetch(theme)
  end

  # 回答入力〜最終確認・回答編集の色。Tailwind が検出できるよう、クラス名は省略せずに書く
  THEME_INPUT_STYLES = {
    "default" => {
      card_border: "border-violet-500",
      chip_checked: "peer-checked:bg-accent-purple peer-checked:border-accent-purple",
      focus_border: "focus:border-accent-purple",
      gradient: "from-accent-purple to-accent-pink",
      outline_button: "border-violet-500 text-violet-500 hover:bg-violet-50",
      step_text: "text-violet-600",
      step_circle: "bg-accent-purple",
      answered_cell: "bg-accent-purple border-accent-purple"
    },
    "friend" => {
      card_border: "border-sky-400",
      chip_checked: "peer-checked:bg-sky-500 peer-checked:border-sky-500",
      focus_border: "focus:border-sky-500",
      gradient: "from-sky-400 to-blue-500",
      outline_button: "border-sky-500 text-sky-500 hover:bg-sky-50",
      step_text: "text-sky-500",
      step_circle: "bg-sky-500",
      answered_cell: "bg-sky-500 border-sky-500"
    }
  }.freeze

  # テーマのない画面（共通情報）は default の色にする
  def theme_input_style(theme)
    THEME_INPUT_STYLES.fetch(theme, THEME_INPUT_STYLES["default"])
  end
end
