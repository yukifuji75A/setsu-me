Answer.delete_all
ManualAiText.delete_all
Manual.delete_all
QuestionOption.delete_all
Question.delete_all
Profile.delete_all
User.delete_all

# ====================
# 共通情報（theme: :common）
# ====================

# Q1: 性格ワード
q = Question.find_or_create_by!(theme: :common, position: 1) do |question|
  question.title = "あなたの性格に一番当てはまるものを選んでください"
  question.answer_type = :selection
end
[
  "明るい", "優しい", "真面目", "マイペース", "好奇心旺盛",
  "人見知り", "聞き上手", "社交的", "面倒見がいい", "行動的",
  "慎重", "ポジティブ", "責任感がある", "負けず嫌い", "冷静",
  "素直", "おおらか", "繊細", "几帳面", "協調的"
].each_with_index do |label, i|
  q.question_options.find_or_create_by!(position: i + 1) { |o| o.label = label }
end

# Q2: MBTI
q = Question.find_or_create_by!(theme: :common, position: 2) do |question|
  question.title = "MBTIを教えてください"
  question.answer_type = :selection
end
[
  "INTJ（建築家）", "INTP（論理学者）", "ENTJ（指揮官）", "ENTP（討論者）",
  "INFJ（提唱者）", "INFP（仲介者）", "ENFJ（主人公）", "ENFP（運動家）",
  "ISTJ（管理者）", "ISFJ（擁護者）", "ESTJ（幹部）", "ESFJ（領事）",
  "ISTP（巨匠）", "ISFP（冒険家）", "ESTP（起業家）", "ESFP（エンターテイナー）",
  "わからない"
].each_with_index do |label, i|
  q.question_options.find_or_create_by!(position: i + 1) { |o| o.label = label }
end

# Q3: 趣味
Question.find_or_create_by!(theme: :common, position: 3) do |question|
  question.title = "あなたの趣味を教えてください"
  question.answer_type = :text
end

# Q4: 思考タイプ
q = Question.find_or_create_by!(theme: :common, position: 4) do |question|
  question.title = "あなたの思考タイプに最も近いものを選んでください"
  question.answer_type = :selection
end
[
  "論理・分析型", "直感・感覚型", "計画・堅実型", "協調・共感型"
].each_with_index do |label, i|
  q.question_options.find_or_create_by!(position: i + 1) { |o| o.label = label }
end

# Q5: 行動タイプ
q = Question.find_or_create_by!(theme: :common, position: 5) do |question|
  question.title = "あなたの行動タイプに最も近いものを選んでください"
  question.answer_type = :selection
end
[
  "主導型", "感化型", "安定型", "慎重型"
].each_with_index do |label, i|
  q.question_options.find_or_create_by!(position: i + 1) { |o| o.label = label }
end

# ====================
# デフォルト追加情報（theme: :default）
# ====================

# Q1: 相性のいいタイプ
q = Question.find_or_create_by!(theme: :default, position: 1) do |question|
  question.title = "あなたと相性がいいと感じる人を選んでください"
  question.answer_type = :selection
end
[
  "明るい人", "優しい人", "誠実な人", "社交的な人",
  "落ち着いた人", "ポジティブな人", "行動的な人", "慎重な人",
  "好奇心旺盛な人", "おおらかな人", "聞き上手な人", "マイペースな人"
].each_with_index do |label, i|
  q.question_options.find_or_create_by!(position: i + 1) { |o| o.label = label }
end

# Q2: 落ち着く環境
Question.find_or_create_by!(theme: :default, position: 2) do |question|
  question.title = "どのような環境だと落ち着いて過ごせますか？"
  question.answer_type = :text
end

# Q3: 嬉しい接し方
q = Question.find_or_create_by!(theme: :default, position: 3) do |question|
  question.title = "どんな接し方をされると嬉しいですか？"
  question.answer_type = :selection
end
[
  "気軽に話しかけてくれる", "話を最後まで聞いてくれる",
  "適度な距離感で接してくれる", "褒めてくれる",
  "頼ってくれる", "気遣ってくれる",
  "一緒に楽しんでくれる", "困っていたら声をかけてくれる"
].each_with_index do |label, i|
  q.question_options.find_or_create_by!(position: i + 1) { |o| o.label = label }
end

# Q4: 好きな話題
Question.find_or_create_by!(theme: :default, position: 4) do |question|
  question.title = "あなたが好きな話題を教えてください"
  question.answer_type = :text
end

# Q5: 苦手なタイプ
q = Question.find_or_create_by!(theme: :default, position: 5) do |question|
  question.title = "あなたが苦手だと感じる人を選んでください"
  question.answer_type = :selection
end
[
  "高圧的な人", "自己中心的な人", "感情的な人", "ネガティブな人",
  "時間にルーズな人", "約束を守らない人", "嘘をつく人", "人の話を聞かない人",
  "マウントを取る人", "細かすぎる人", "空気を読まない人", "自慢が多い人"
].each_with_index do |label, i|
  q.question_options.find_or_create_by!(position: i + 1) { |o| o.label = label }
end

# Q6: 苦手な環境
Question.find_or_create_by!(theme: :default, position: 6) do |question|
  question.title = "どのような環境が苦手ですか？"
  question.answer_type = :text
end

# Q7: 苦手な接し方
q = Question.find_or_create_by!(theme: :default, position: 7) do |question|
  question.title = "苦手・困ってしまう接し方を選んでください"
  question.answer_type = :selection
end
[
  "強く否定される", "急かされる", "干渉されすぎる", "無視される",
  "大勢の前で指摘される", "大きな声で話される",
  "プライベートに踏み込まれる", "一方的に話される"
].each_with_index do |label, i|
  q.question_options.find_or_create_by!(position: i + 1) { |o| o.label = label }
end

# Q8: 地雷
Question.find_or_create_by!(theme: :default, position: 8) do |question|
  question.title = "「これは苦手」「これだけは避けてほしい」と思うことがあれば教えてください"
  question.answer_type = :text
end

# Q9: シチュエーション1
q = Question.find_or_create_by!(theme: :default, position: 9) do |question|
  question.title = "あなたが「知っておいてほしい」と思う状況を選んでください"
  question.answer_type = :selection
end
[
  "落ち込んでいるとき", "困っているとき", "緊張しているとき", "ストレスを感じているとき",
  "疲れているとき", "悩んでいるとき", "集中しているとき", "一人になりたいとき"
].each_with_index do |label, i|
  q.question_options.find_or_create_by!(position: i + 1) { |o| o.label = label }
end

# Q10: 対処法1
Question.find_or_create_by!(theme: :default, position: 10) do |question|
  question.title = "Q9で選んだ状況のとき、どのように接してもらえると嬉しいですか？"
  question.answer_type = :text
end

# Q11: シチュエーション2
q = Question.find_or_create_by!(theme: :default, position: 11) do |question|
  question.title = "もう一つ、「知っておいてほしい」と思う状況を選んでください"
  question.answer_type = :selection
end
[
  "落ち込んでいるとき", "困っているとき", "緊張しているとき", "ストレスを感じているとき",
  "疲れているとき", "悩んでいるとき", "集中しているとき", "一人になりたいとき"
].each_with_index do |label, i|
  q.question_options.find_or_create_by!(position: i + 1) { |o| o.label = label }
end

# Q12: 対処法2
Question.find_or_create_by!(theme: :default, position: 12) do |question|
  question.title = "Q11で選んだ状況のとき、どのように接してもらえると嬉しいですか？"
  question.answer_type = :text
end
