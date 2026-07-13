# ====================
# 共通情報（theme: :common）
# ====================

# Q1: 性格タイプ
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

# Q3: 大切なもの
q = Question.find_or_create_by!(theme: :common, position: 3) do |question|
  question.title = "あなたにとって一番大切なものを選んでください"
  question.answer_type = :selection
end
[
  "家族", "友人", "パートナー", "健康", "自由",
  "成長", "安定", "挑戦", "楽しさ", "趣味",
  "仕事・学業", "お金", "時間", "信頼", "誠実さ"
].each_with_index do |label, i|
  q.question_options.find_or_create_by!(position: i + 1) { |o| o.label = label }
end

# Q4: 趣味
Question.find_or_create_by!(theme: :common, position: 4) do |question|
  question.title = "あなたの趣味を教えてください"
  question.answer_type = :text
end

# Q5: 好きなもの・こと
Question.find_or_create_by!(theme: :common, position: 5) do |question|
  question.title = "あなたが好きなもの・好きなことを教えてください"
  question.answer_type = :text
end

# Q6: 苦手なもの・こと
Question.find_or_create_by!(theme: :common, position: 6) do |question|
  question.title = "あなたが苦手なもの・苦手なことを教えてください"
  question.answer_type = :text
end

# ====================
# デフォルト追加情報（theme: :default）
# ====================

# Q1: 初対面の様子
q = Question.find_or_create_by!(theme: :default, position: 1) do |question|
  question.title = "初対面ではどんな様子になることが多いですか？"
  question.answer_type = :selection
end
[
  "緊張しやすい", "少し緊張する", "あまり緊張しない", "自然体でいられる", "相手による"
].each_with_index do |label, i|
  q.question_options.find_or_create_by!(position: i + 1) { |o| o.label = label }
end

# Q2: 仲良くなるきっかけ
q = Question.find_or_create_by!(theme: :default, position: 2) do |question|
  question.title = "仲良くなるきっかけはどちらからが多いですか？"
  question.answer_type = :selection
end
[
  "自分から話しかけることが多い",
  "相手から話しかけてもらうことが多い",
  "自然と仲良くなることが多い",
  "相手による"
].each_with_index do |label, i|
  q.question_options.find_or_create_by!(position: i + 1) { |o| o.label = label }
end

# Q3: 嬉しい接し方
q = Question.find_or_create_by!(theme: :default, position: 3) do |question|
  question.title = "どんな接し方をされると嬉しいですか？"
  question.answer_type = :selection
end
[
  "気軽に話しかけてくれる", "話を最後まで聞いてくれる", "褒めてくれる",
  "頼ってくれる", "適度な距離感で接してくれる", "困っていたら声をかけてくれる",
  "一緒に楽しんでくれる"
].each_with_index do |label, i|
  q.question_options.find_or_create_by!(position: i + 1) { |o| o.label = label }
end

# Q4: 苦手な接し方
q = Question.find_or_create_by!(theme: :default, position: 4) do |question|
  question.title = "苦手・困ってしまう接し方を教えてください"
  question.answer_type = :selection
end
[
  "強く否定される", "急かされる", "干渉されすぎる",
  "約束を守らない", "無理に話しかけられる", "大きな声で話される", "嘘をつかれる"
].each_with_index do |label, i|
  q.question_options.find_or_create_by!(position: i + 1) { |o| o.label = label }
end

# Q5: 落ち込んでいるとき
q = Question.find_or_create_by!(theme: :default, position: 5) do |question|
  question.title = "落ち込んでいるときは、どのように接してもらえると嬉しいですか？"
  question.answer_type = :selection
end
[
  "そっとしておいてほしい", "話を聞いてほしい", "励ましてほしい",
  "気分転換に誘ってほしい", "普段どおり接してほしい"
].each_with_index do |label, i|
  q.question_options.find_or_create_by!(position: i + 1) { |o| o.label = label }
end

# Q6: モチベーション
q = Question.find_or_create_by!(theme: :default, position: 6) do |question|
  question.title = "モチベーションが上がるのはどんなときですか？"
  question.answer_type = :selection
end
[
  "褒められたとき", "感謝されたとき", "頼られたとき",
  "成長を実感したとき", "目標を達成したとき", "自由に取り組めるとき", "仲間と協力するとき"
].each_with_index do |label, i|
  q.question_options.find_or_create_by!(position: i + 1) { |o| o.label = label }
end

# Q7: 困っているとき
q = Question.find_or_create_by!(theme: :default, position: 7) do |question|
  question.title = "困っているとき、どのように接してもらえると助かりますか？"
  question.answer_type = :selection
end
[
  "声をかけてほしい", "必要なときだけ助けてほしい",
  "自分から相談するまで待ってほしい", "一緒に考えてほしい", "解決方法を教えてほしい"
].each_with_index do |label, i|
  q.question_options.find_or_create_by!(position: i + 1) { |o| o.label = label }
end

# Q8: 好きな話題
Question.find_or_create_by!(theme: :default, position: 8) do |question|
  question.title = "一番盛り上がれる「好きな話題」を教えてください"
  question.answer_type = :text
end

# Q9: 好調のサイン
Question.find_or_create_by!(theme: :default, position: 9) do |question|
  question.title = "好調のサインを教えてください"
  question.answer_type = :text
end

# Q10: 不調のサイン
Question.find_or_create_by!(theme: :default, position: 10) do |question|
  question.title = "不調のサインを教えてください"
  question.answer_type = :text
end

# Q11: 元気が出るもの・こと
Question.find_or_create_by!(theme: :default, position: 11) do |question|
  question.title = "元気が出るもの・ことを教えてください"
  question.answer_type = :text
end

# Q12: ストレス発散方法
Question.find_or_create_by!(theme: :default, position: 12) do |question|
  question.title = "ストレス発散方法を教えてください"
  question.answer_type = :text
end

# Q13: テンションが上がる瞬間
Question.find_or_create_by!(theme: :default, position: 13) do |question|
  question.title = "テンションが上がる瞬間を教えてください"
  question.answer_type = :text
end

# Q14: 地雷
Question.find_or_create_by!(theme: :default, position: 14) do |question|
  question.title = "あなたの地雷を教えてください（絶対にやめてほしいこと、これだけはNG！なことなど）"
  question.answer_type = :text
end
