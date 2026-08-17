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
    "friend" => {}
  }.freeze

  def answer_placeholder(theme, question)
    ANSWER_PLACEHOLDERS.dig(theme, question.position) || "入力してください"
  end
end
