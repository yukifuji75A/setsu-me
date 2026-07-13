class ManualGeneratorService
  def initialize(user)
    @user = user
  end

  def call
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        response_format: { type: "json_object" },
        messages: [
          { role: "system", content: system_prompt },
          { role: "user", content: user_prompt }
        ]
      }
    )

    result = JSON.parse(response.dig("choices", 0, "message", "content"))
    { basic_spec: result["basic_spec"], handling_guide: result["handling_guide"] }
  end

  private

  def system_prompt
    <<~PROMPT
      あなたは2種類の文章を生成する専門家です。
      必ず以下のJSON形式のみ返却してください：
      {"basic_spec": "...", "handling_guide": "..."}
    PROMPT
  end

  def user_prompt
    <<~PROMPT
      以下の指示に従って2種類の文章を生成してください。

      ===

      【basic_spec：第1章 製品概要の人物紹介文】

      あなたは「人間を製品に見立てた取扱説明書」を作成する専門のコピーライターです。

      目的：
      この文章は、「人間の取扱説明書」の第1章「製品概要」に掲載される人物紹介文です。
      初めて取扱説明書を読む人が、「本モデルはどのような人物なのか」を短時間で理解できるよう、その人物らしさを簡潔にまとめてください。

      条件：
      ・60〜90文字程度
      ・第三者視点で書く
      ・「本モデル」「この人物」など、取扱説明書らしい表現を自然に使用する
      ・家電製品の取扱説明書をイメージした、客観的で読みやすい文体にする
      ・です・ます調で書く
      ・性格、価値観、コミュニケーションの特徴を中心にまとめる
      ・趣味や好きなものは、人物像を表す場合のみ自然に含める
      ・MBTI・思考タイプ・行動タイプは参考情報として扱い、それだけで人物像を決めつけない
      ・すべての情報を使用する必要はありません。人物像を表現するために必要な情報を選び、自然な文章にしてください。
      ・入力内容から推測できる範囲でまとめる
      ・誇張や創作はしない
      ・箇条書きは禁止
      ・余計な説明は出力しない
      ・性別を示す表現（「彼」「彼女」「男性」「女性」など）は使用しない

      出力例：
      本モデルは穏やかで思いやりがあり、人との信頼関係を大切にするタイプです。初対面は慎重ですが、打ち解けると自然なコミュニケーションを楽しめます。

      ユーザー情報：
      #{introduction_lines}

      ===

      【handling_guide：自己分析レポート】

      あなたは人物分析の専門家です。

      目的：
      以下のユーザー情報をもとに、本人が自己理解を深められる自己分析レポートを作成してください。
      このレポートは本人だけが閲覧します。
      性格や価値観だけでなく、人との関わり方や心地よい環境なども踏まえ、客観的かつ前向きに分析してください。

      条件：
      ・500〜800文字程度
      ・第二者視点（「あなたは〜です」「〜な傾向があります」）
      ・見出しは使わず、各段落の冒頭に「【あなたの特徴】」のようなラベルを付ける
      ・各段落は「あなたの特徴」「コミュニケーション」「力を発揮しやすい環境」「AIからのメッセージ」の順で構成する
      ・段落と段落の間は必ず改行コード\nを2つ挿入して区切る
      ・性格、価値観、コミュニケーション、得意な環境を総合的に分析する
      ・回答内容を並べるのではなく、それぞれの情報を関連付けて分析する
      ・MBTI・思考タイプ・行動タイプは参考情報として扱い、それだけで人物像を決めつけない
      ・すべての情報を無理に使用する必要はありません。分析に必要な情報を選び、自然にまとめてください。
      ・入力内容から推測できる範囲で分析する
      ・誇張や創作はしない
      ・前向きで温かみのある文章にする
      ・箇条書きは禁止
      ・余計な説明は出力しない
      ・マークダウン記法（#・*・**など）は使用しない

      ユーザー情報：
      #{analysis_lines}
    PROMPT
  end

  def introduction_lines
    common = answers_for(:common, positions: [ 1, 2, 3, 4, 5 ])
    default = answers_for(:default, positions: [ 1, 3 ])
    format_lines(common + default)
  end

  def analysis_lines
    common = answers_for(:common, positions: [ 1, 2, 3, 4, 5 ])
    default = answers_for(:default, positions: [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ])
    format_lines(common + default)
  end

  def answers_for(theme, positions:)
    @user.answers
         .joins(:question)
         .where(questions: { theme: theme, position: positions })
         .includes(:question, :question_option)
         .sort_by { |a| a.question.position }
  end

  def format_lines(answers)
    answers.map do |answer|
      value = answer.question.selection? ? answer.question_option&.label : answer.body
      "#{answer.question.title}：#{value}"
    end.join("\n")
  end
end
