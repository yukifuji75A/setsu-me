class ManualGeneratorService
  POSITIONS = {
    "default" => {
      introduction: [ 1, 3 ],
      analysis: (1..12).to_a
    },
    "friend" => {
      introduction: [ 13, 14, 15, 16, 17, 18 ],
      analysis: (1..18).to_a
    }
  }.freeze

  def initialize(user, theme)
    @user = user
    @theme = theme
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
    if @theme == "default"
      <<~PROMPT
        あなたは2種類の文章を生成する専門家です。
        必ず以下のJSON形式のみ返却してください：
        {"basic_spec": "...", "handling_guide": "..."}
      PROMPT
    else
      <<~PROMPT
        あなたは文章を生成する専門家です。
        必ず以下のJSON形式のみ返却してください：
        {"basic_spec": "..."}
      PROMPT
    end
  end

  def user_prompt
    if @theme == "default"
      <<~PROMPT
        以下の指示に従って2種類の文章を生成してください。

        #{basic_spec_prompt}

        ===

        #{handling_guide_prompt}
      PROMPT
    else
      <<~PROMPT
        以下の指示に従って文章を生成してください。

        #{basic_spec_prompt}
      PROMPT
    end
  end

  def basic_spec_prompt
    @theme == "default" ? default_basic_spec_prompt : friend_basic_spec_prompt
  end

  def default_basic_spec_prompt
    <<~PROMPT
      【basic_spec：第1章 製品概要の人物紹介文】

      あなたは「人間を製品に見立てた取扱説明書」を作成する専門のコピーライターです。

      目的：
      この文章は、「人間の取扱説明書」の第1章「製品概要」に掲載される人物紹介文です。
      初めて取扱説明書を読む人が、「本モデルはどのような人物なのか」を短時間で理解できるよう、その人物らしさを簡潔にまとめてください。

      条件：
      ・100〜140文字程度
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
    PROMPT
  end

  def friend_basic_spec_prompt
    <<~PROMPT
      【basic_spec：友だち向けトリセツ・第1章】

      あなたは、友だちに共有する「自分専用のトリセツ」を作成するコピーライターです。

      目的：
      この文章は、友だちに共有する「友だち向けトリセツ」の第1章に掲載する人物紹介文です。

      回答内容から、この人物が友だちとしてどのような付き合い方をする人なのかを読み取り、文章を読んだ友だちが「この人とはどんなふうに付き合えそうか」「仲良くなるとどんな感じなのか」を自然にイメージできる文章を作成してください。

      単なる性格紹介や回答内容の要約ではなく、複数の回答を関連付けて、この人物らしい友だち付き合いの特徴を一つの文章として表現してください。

      文章の雰囲気：
      ・この人物自身が、友だちに自分のことを教えているような文章にする
      ・友だち同士で話すような、自然で親しみやすい言葉を使う
      ・「〜だよ」「〜しやすいよ」「〜すると、こんな一面も見えてくるよ」などの口語表現を自然に使用する
      ・敬語や堅苦しい表現は使用しない
      ・説明書、業務文書、心理分析レポートのような淡々とした文章にしない
      ・「本モデル」「仕様」「運用」「適しています」など、一般的な製品説明書を連想させる硬い表現は使用しない
      ・少しだけユーモアや親しみを感じられる表現を入れてもよい
      ・馴れ馴れしすぎたり、幼稚な文章になったりしない

      内容：
      ・友だちとしての付き合い方が最も伝わる内容を優先する
      ・仲良くなるまでの距離感と、仲良くなった後の変化を必要に応じて関連付ける
      ・連絡頻度、遊ぶ頻度、直前のお誘いへの反応、誘う・誘われる傾向などから、友だちとの付き合いやすいペースを読み取る
      ・一人の時間と友だちとの時間のバランスから、心地よい距離感を読み取る
      ・悩み相談への希望、意見が違ったときの対応、友だち関係で大切にしていることから、友だちとの関わり方を読み取る
      ・「仲良くなるとこうなります」の回答は、親しくなった後の人物像を表現するために積極的に活用する
      ・好きなものや遊びの情報が与えられている場合、それを性格の根拠として無理に分析せず、友だちと一緒に楽しめることを表現するために必要な場合のみ使用する
      ・回答を一問ずつ説明したり、選択肢をそのまま並べたりしない
      ・提供された情報をすべて文章に含める必要はない
      ・友だちとしての人物像を表現するうえで重要な情報を優先し、文章として自然につながる情報だけを使用する
      ・情報を無理に詰め込んで、単なる回答の羅列にならないようにする
      ・文字数を満たすためだけに不要な情報を追加しない
      ・回答から明確に読み取れない性格や価値観を推測して断定しない
      ・MBTIなどの情報がある場合も、それだけを根拠に人物像を決めつけない
      ・誇張や創作はしない

      条件：
      ・100〜140文字程度
      ・一つのまとまった文章として書く
      ・友だち本人から説明されているような自然な文章にする
      ・文章の流れを重視し、複数の回答を自然に関連付ける
      ・箇条書きは禁止
      ・マークダウン記法は禁止
      ・余計な説明や前置きは出力しない
      ・性別を示す表現（「彼」「彼女」「男性」「女性」など）は使用しない

      出力例：
      無理に距離を縮めるより、自然なペースで仲良くなるタイプだよ。連絡や遊ぶ頻度もお互いに無理のないくらいがちょうどいい。仲良くなると会話も増えて、気を許した相手にはだんだん素の一面が見えてくるよ。

      ユーザー情報：
      #{introduction_lines}
    PROMPT
  end

  def handling_guide_prompt
    <<~PROMPT
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
    theme_answers = answers_for(@theme, positions: POSITIONS[@theme][:introduction])
    format_lines(common + theme_answers)
  end

  def analysis_lines
    common = answers_for(:common, positions: [ 1, 2, 3, 4, 5 ])
    theme_answers = answers_for(@theme, positions: POSITIONS[@theme][:analysis])
    format_lines(common + theme_answers)
  end

  def answers_for(theme, positions:)
    @user.answers
         .for_theme(theme)
         .merge(Question.where(position: positions))
         .sort_by { |a| a.question.position }
  end

  def format_lines(answers)
    answers.map do |answer|
      value = answer.question.selection? ? answer.question_option&.label : answer.body
      "#{answer.question.title}：#{value}"
    end.join("\n")
  end
end
