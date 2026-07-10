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
      あなたは「人間の取扱説明書」を書く専門のコピーライターです。
      家電製品の取扱説明書を模した文体で執筆してください。
      「本モデル」などの製品風表現を使い、クスッと笑えるユーモアを1〜2箇所入れてください。
      です・ます調で書き、箇条書きは禁止です。余計な説明も不要です。
      性別を示す表現（「彼」「彼女」「男性」「女性」など）は使わず、「この人物」「本モデル」などの表現で統一してください。
      必ず以下のJSON形式のみ返却してください：
      {"basic_spec": "...", "handling_guide": "..."}
    PROMPT
  end

  def user_prompt
    answers = @user.answers
                   .joins(:question)
                   .where(questions: { theme: [ :common, :default ] })
                   .includes(:question, :question_option)
                   .sort_by { |a| [ a.question.theme == "common" ? 0 : 1, a.question.position ] }

    lines = answers.map do |answer|
      value = answer.question.selection? ? answer.question_option&.label : answer.body
      "#{answer.question.title}：#{value}"
    end

    <<~PROMPT
      以下の情報をもとに取扱説明書を作成してください。

      【基本スペック（150〜250文字）】
      「本モデル」から書き始め、性格・価値観・趣味を盛り込んでください。

      【取扱いガイド（150〜250文字）】
      「取扱い上の注意」を1度使い、接し方ガイドを記述してください。

      【ユーザー情報】
      #{lines.join("\n")}
    PROMPT
  end
end
