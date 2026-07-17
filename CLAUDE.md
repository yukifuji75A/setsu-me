# SETSU:Me — CLAUDE.md

## プロジェクト概要

性格・価値観・モチベーションなどを入力するとAIが「取扱説明書（トリセツ）」を自動生成し、URLで共有できるサービス。新しい環境での自己紹介・相互理解の時間短縮が目的。

---

## 技術スタック

| カテゴリ | 技術 | バージョン |
|------|------|------|
| バックエンド | Ruby on Rails | 7.2.x |
| Ruby | Ruby | 3.3.8 |
| フロントエンド | Tailwind CSS / Hotwire (Turbo + Stimulus) | - |
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

## DBスキーマ

### Users（ユーザー認証）
| カラム | 型 | 制約 | 備考 |
|------|------|------|------|
| email | string | UQ / NN | 通常登録時は必須、LINE登録時は空を許容（本リリースでマイグレーション予定） |
| encrypted_password | string | NN | 通常登録時は必須、LINE登録時は空を許容（本リリースでマイグレーション予定） |
| provider | string | - | OAuthのプロバイダ名（LINE）（本リリースで追加予定） |
| uid | string | - | LINE側の一意のユーザーID / providerと複合UNIQUE（本リリースで追加予定） |
| created_at / updated_at | datetime | NN | |

### Profiles（プロフィール情報）
| カラム | 型 | 制約 | 備考 |
|------|------|------|------|
| user_id | bigint | FK / UQ / NN | usersへの外部キー |
| name | string | NN | 表示名（ニックネーム） |
| birthday | date | NN | 誕生日（年齢・星座を計算で導出） |
| hometown | integer | NN | 出身（enum: 47都道府県） |
| education | integer | NN | 学歴（enum: 中学卒〜大学院卒、その他） |
| blood_type | integer | NN | 血液型（enum: A/B/O/AB） |
| created_at / updated_at | datetime | NN | |

### Manuals（トリセツ本体・テーマ管理）
| カラム | 型 | 制約 | 備考 |
|------|------|------|------|
| user_id | bigint | FK / NN | usersテーブルへの外部キー |
| theme | integer | NN | テーマの種類（enum: 0:デフォルト / 1:恋人 / 2:友だち）/ user_idと複合UNIQUE |
| share_token | string | UQ / NN | 外部共有URL用の文字列 |
| created_at / updated_at | datetime | NN | |

### Manual_ai_texts（AI生成・編集文章）
| カラム | 型 | 制約 | 備考 |
|------|------|------|------|
| manual_id | bigint | FK / NN | manualsテーブルへの外部キー |
| section_type | integer | NN | どの項目の文章か（enum: 項目ごとに定義）/ manual_idと複合UNIQUE |
| ai_text | text | NN | AIが生成したオリジナルの文章 |
| user_edited_text | text | - | ユーザーが編集・上書きした文章（本リリースでUI実装予定） |
| created_at / updated_at | datetime | NN | |

### Questions（質問マスタ）
| カラム | 型 | 制約 | 備考 |
|------|------|------|------|
| theme | integer | NN | 質問の対象テーマ（enum: 共通 / デフォルト / 恋人 / 友だち） |
| title | string | NN | 質問文（例：「MBTIタイプは？」など） |
| answer_type | integer | NN | 回答のタイプ（enum: 選択式 / 記述式 / スコア型） |
| position | integer | NN | 質問の表示順・並び替え用 |
| created_at / updated_at | datetime | NN | |

### Question_options（選択肢マスタ）
| カラム | 型 | 制約 | 備考 |
|------|------|------|------|
| question_id | bigint | FK / NN | どの質問に対する選択肢か |
| label | string | NN | 選択肢のテキスト |
| position | integer | NN | 選択肢の表示順・並び替え用 |
| created_at / updated_at | datetime | NN | |

### Answers（ユーザー回答）
| カラム | 型 | 制約 | 備考 |
|------|------|------|------|
| user_id | bigint | FK / NN | どのユーザーの回答か |
| question_id | bigint | FK / NN | どの質問への回答か / user_idと複合UNIQUE |
| question_option_id | bigint | FK | 選択式の場合の選んだ選択肢ID |
| body | text | - | 記述式の場合の回答テキスト |
| score | integer | - | 数値形式の回答（グラフ集計用） |
| created_at / updated_at | datetime | NN | |

---

## 本リリース実装予定

### 機能
- LINE連携（OmniAuth + omniauth-line）
- 外部共有機能（共有URL発行・ログイン不要閲覧・LINEシェア）
- マルチテーマ機能（恋人・友だち）
- トリセツ編集・AI生成文章のユーザー編集・AI再生成（回数制限付き）
- レーダーチャート（Chart.js）+ 回答スコア導入
- プロフィール画像アップロード（Active Storage + S3）
- AI文章生成の非同期処理（Sidekiq + Redis）
- アカウント設定（メアド・パスワード変更、利用規約、プライバシーポリシー）

### 技術・品質
- RSpec導入 + カバレッジ測定（SimpleCov等）
- CI導入（GitHub Actions）
- N+1対策（Bullet等）
- Fat Controller / Fat Model の解消

---


## 開発ルール

- issueごとに作業ブランチを作成して作業すること
- 新しいブランチの作業開始時は、そのブランチで実装する内容と工程を最初に提示すること
- 新しいビューファイルを追加したとき、または初めて使うTailwindクラスを追加したときは `rails tailwindcss:build` を実行すること（Docker内では `docker-compose exec web rails tailwindcss:build`）
- コミット前に rubocop を実施し、lintエラーを解消してからコミットすること
- マージ前にブラウザ上で実装した内容通りの動作ができているか確認すること
- 指示や意図が曖昧な場合、または理解できない場合は推測で進めず確認をとること