# SETSU:Me — CLAUDE.md

## プロジェクト概要

性格・価値観・モチベーションなどを入力するとAIが「取扱説明書（トリセツ）」を自動生成し、URLで共有できるサービス。新しい環境での自己紹介・相互理解の時間短縮が目的。

---

## 技術スタック

| カテゴリ | 技術 | バージョン |
|------|------|------|
| バックエンド | Ruby on Rails | 7.2.x |
| Ruby | Ruby | 3.3.8 |
| フロントエンド | Tailwind CSS + DaisyUI / Hotwire (Turbo + Stimulus) | - |
| DB | PostgreSQL | 16 |
| 認証 | Devise + OmniAuth (LINE連携は本リリース) | - |
| AI | OpenAI API (gpt-4o-mini) | - |
| 非同期処理 | Sidekiq + Redis | 本リリースのみ |
| 画像管理 | Active Storage + Amazon S3 | 本リリースのみ |
| インフラ | Docker (開発環境のみ) | - |
| デプロイ | Render (ネイティブRailsデプロイ、Docker不使用) | - |

---

## 開発環境

```bash
# 起動
docker-compose up

# Rails コマンド実行
docker-compose exec web rails <command>

# DB作成
docker-compose exec web rails db:create
```

- ローカルURL: http://localhost:3000
- DB: setsu_me_development / setsu_me_test

---

## 現在の進捗

### Week 1（6/30〜7/6）

| # | タスク | 状態 |
|---|------|------|
| 1 | GitHubリポジトリ作成 | ✅ 完了 |
| 2 | rails new + Docker環境構築 | ✅ 完了 |
| 3 | 仮TOPページ作成・ルーティング確認 | ✅ 完了 |
| 4 | Renderデプロイ・本番動作確認 | ⬜ 未着手 |
| 5 | Gem導入・Tailwind CSS + DaisyUI + Hotwire設定 | ⬜ 未着手 |
| 6 | マイグレーション・モデル・ルーティング設計・シード作成 | ⬜ 未着手 |
| 7 | Devise設定・ユーザー登録・ログイン画面実装 | ⬜ 未着手 |
| 8 | プロフィール設定・編集画面実装 | ⬜ 未着手 |
| 9 | OpenAI APIキー取得・接続確認 | ⬜ 未着手 |
| 10 | README技術スタック最終更新 | ⬜ 未着手 |

### Week 2（7/7〜7/12）

| # | タスク | 状態 |
|---|------|------|
| 11 | 共通情報入力画面UI実装 | ⬜ 未着手 |
| 12 | 多ステップフォーム（都度DBへ保存）実装 | ⬜ 未着手 |
| 13 | トリセツ作成①（追加入力）画面実装 | ⬜ 未着手 |
| 14 | AI文章生成API連携実装 | ⬜ 未着手 |
| 15 | トリセツ作成②（生成・編集）画面実装 | ⬜ 未着手 |
| 16 | トリセツ作成③（最終確認）画面実装 | ⬜ 未着手 |
| 17 | マイページ（基本情報・AI分析タブ）実装 | ⬜ 未着手 |
| 18 | トリセツ管理・プレビュー画面実装 | ⬜ 未着手 |
| 19 | UI調整・バグ修正・最終デプロイ・動作確認 | ⬜ 未着手 |

---

## 現在のコード構成

```
app/
  controllers/
    pages_controller.rb      # TOPページ（仮）
  views/
    pages/top.html.erb       # 仮TOPページ（ログイン画面に後で置き換え）
    layouts/application.html.erb
config/
  routes.rb                  # root → pages#top
  database.yml               # DB_HOST / DB_USER / DB_PASSWORD を環境変数で管理
  brakeman.yml               # confidence_level: 2（EOLRails警告を除外）
.ruby-version                # 3.3.8
Dockerfile                   # ruby:3.3-slim
docker-compose.yml           # web + db (postgres:16-alpine)
.github/workflows/ci.yml     # lint / scan_ruby(-w 2) / scan_js
```

---

## MVPスコープ

### 実装する機能
1. 認証・ユーザー管理（ログイン・ユーザー登録）
2. トリセツ作成（情報入力・AI文章生成・同期処理）
3. マイページ（基本情報 / AI分析 タブ切り替え）
4. トリセツ管理（プレビュー表示）

### MVPに含まない機能（本リリース）
- LINE連携
- 外部共有URL・LINE共有
- マルチテーマ（恋人・友だち）
- トリセツ編集・AI再生成
- レーダーチャート
- プロフィール画像アップロード
- 非同期処理（Sidekiq）

---

## DBスキーマ（確定）

### Users
| カラム | 型 | 制約 |
|------|------|------|
| email | string | UQ / NN |
| encrypted_password | string | NN |
| provider | string | - |
| uid | string | - |
| created_at / updated_at | datetime | NN |

### Profiles
| カラム | 型 | 制約 | 備考 |
|------|------|------|------|
| user_id | bigint | FK / UQ / NN | |
| name | string | NN | 表示名 |
| birthday | date | NN | 年齢・星座を計算で導出 |
| hometown | integer | NN | enum: 47都道府県 |
| education | integer | NN | enum: 中学卒/高校卒/専門学校卒/短大卒/大学卒/大学院卒/その他 |
| blood_type | integer | NN | enum: A/B/O/AB |
| created_at / updated_at | datetime | NN | |

### Manuals（トリセツ本体）
| カラム | 型 | 制約 | 備考 |
|------|------|------|------|
| user_id | bigint | FK / NN | |
| theme | integer | NN | enum: 0:デフォルト / 1:恋人 / 2:友だち。user_idと複合UNIQUE |
| share_token | string | UQ / NN | 外部共有URL用（MVPではUI非表示） |
| created_at / updated_at | datetime | NN | |

### Manual_ai_texts（AI生成文章）
| カラム | 型 | 制約 | 備考 |
|------|------|------|------|
| manual_id | bigint | FK / NN | |
| section_type | integer | NN | enum: 0:基本スペック / 1:取扱いガイド。manual_idと複合UNIQUE |
| ai_text | text | NN | AIが生成したオリジナル文章 |
| user_edited_text | text | - | ユーザー編集文章（本リリース） |
| created_at / updated_at | datetime | NN | |

### Questions（質問マスタ）
| カラム | 型 | 制約 | 備考 |
|------|------|------|------|
| theme | integer | NN | enum: 0:共通 / 1:デフォルト / 2:恋人 / 3:友だち |
| title | string | NN | 質問文 |
| answer_type | integer | NN | enum: 0:選択式 / 1:記述式 / 2:スコア型 |
| position | integer | NN | 表示順 |
| created_at / updated_at | datetime | NN | |

### Question_options（選択肢マスタ）
| カラム | 型 | 制約 |
|------|------|------|
| question_id | bigint | FK / NN |
| label | string | NN |
| position | integer | NN |
| created_at / updated_at | datetime | NN |

### Answers（ユーザー回答）
| カラム | 型 | 制約 | 備考 |
|------|------|------|------|
| user_id | bigint | FK / NN | user_idとquestion_idで複合UNIQUE |
| question_id | bigint | FK / NN | |
| question_option_id | bigint | FK | 選択式のみ使用 |
| body | text | - | 記述式の回答テキスト |
| score | integer | - | スコア型・グラフ集計用（本リリース） |
| created_at / updated_at | datetime | NN | |

---

## 質問設計（シードデータ）

### 共通情報（theme: 0）全8問

| # | 質問 | タイプ |
|---|------|------|
| 1 | あなたの性格に一番当てはまるものを選んでください | 選択式（20択） |
| 2 | MBTIをご存じであれば教えてください（任意） | 選択式（16種＋わからない） |
| 3 | あなたの思考タイプに最も近いものを選んでください | 選択式（4択） |
| 4 | あなたの行動タイプに最も近いものを選んでください | 選択式（4択） |
| 5 | あなたにとって一番大切なものを選んでください | 選択式（15択） |
| 6 | あなたの趣味を教えてください | 記述式 |
| 7 | あなたが好きなもの・好きなことを教えてください | 記述式 |
| 8 | あなたが苦手なもの・苦手なことを教えてください | 記述式 |

### デフォルト追加情報（theme: 1）全12問

| # | 質問 | タイプ |
|---|------|------|
| 1 | 初対面ではどんな様子になることが多いですか？ | 選択式（5択） |
| 2 | 仲良くなるきっかけはどちらからが多いですか？ | 選択式（4択） |
| 3 | どんな接し方をされると嬉しいですか？ | 選択式（7択） |
| 4 | 苦手・困ってしまう接し方を教えてください | 選択式（7択） |
| 5 | 落ち込んでいるときはどのように接してもらえると嬉しいですか？ | 選択式（5択） |
| 6 | モチベーションが上がるのはどんなときですか？ | 選択式（7択） |
| 7 | 困っているときどのように接してもらえると助かりますか？ | 選択式（5択） |
| 8 | 一番盛り上がれる「好きな話題」を教えてください | 記述式 |
| 9 | あまり突っ込んでほしくない「NGな話題」を教えてください | 記述式 |
| 10 | 「これなら頼って！」と言える得意なことを教えてください | 記述式 |
| 11 | あなたが苦手なことを教えてください | 記述式 |
| 12 | 上記以外で一番知っておいてほしいことがあれば（任意） | 記述式 |

---

## AI生成設計

### 方針
- OpenAI API（gpt-4o-mini）を使用
- 発行ボタン押下時のみ生成（同期処理、MVPはSidekiq不使用）
- 1回のAPIリクエストでJSON形式で2セクションを同時生成
- エラー時は「もう一度お試しください」表示のみ

### セクション構成（MVPはデフォルトテーマのみ）
| section_type | 名称 | 元データ |
|------|------|------|
| 0 | 基本スペック | 共通情報（Q1〜Q8）の回答 |
| 1 | 取扱いガイド | デフォルト追加情報（Q1〜Q12）の回答 |

### AIへのデータ参照ルール
- デフォルトManualのAI生成時：`Questions.theme IN (0:共通, 1:デフォルト)` の回答を使用
- 回答は `Answers` テーブルから `user_id + question_id` で取得

### プロンプト構造

**システムプロンプト（共通）**
```
あなたは「人間の取扱説明書」を書く専門のコピーライターです。
家電製品の取扱説明書を模した文体で執筆。
「本モデル」などの製品風表現 + クスッと笑えるユーモア1〜2箇所。
です・ます調、箇条書き禁止、余計な説明禁止。
必ず以下のJSON形式のみ返却：
{"basic_spec": "...", "handling_guide": "..."}
```

**出力形式**
```json
{
  "basic_spec": "150〜250文字。「本モデル」から書き始め、性格・価値観・趣味を盛り込む",
  "handling_guide": "150〜250文字。「取扱い上の注意」を1度使い、接し方ガイドを記述"
}
```

**Rails実装イメージ**
```ruby
response_format: { type: "json_object" }  # JSON確定
result = JSON.parse(response.dig("choices", 0, "message", "content"))
# result["basic_spec"] と result["handling_guide"] を保存
```

---

## 重要な設計決定事項

- **選択式は全て単数選択**（複数選択は本リリース）
- **share_token はMVP時点からDBに保存**（UIは非表示）
- **年齢・星座はbirthdayから計算**（DBカラムなし）
- **AI文章生成は同期処理**（Sidekiqは本リリース）
- **Profilesは全項目必須**
- **Renderデプロイはネイティブ方式**（本番Dockerfile不要）
- **RSpecはMVP後に追加**（現在テストなし）
