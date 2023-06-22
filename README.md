# Serve (アプリケーション概要)
Serve(サーブ)は好みのコーヒーやコーヒー豆の情報をメモ感覚で投稿するアプリケーションです。  
「商品名」「ショップ名」などとともに、「淹れ方」など詳細まで記録できます。  
レスポンシブ対応しております。(確認しておりますが、表示崩れなどある場合はすぐに修正いたします。)
<br>
<br>
<img width="400" alt="top_page" src="https://github.com/Juniquey/my_app/assets/107200906/8e4efdaa-bf7a-41a0-928e-7b19211ff81d">
<img width="400" alt="post_detail_page" src="https://github.com/Juniquey/my_app/assets/107200906/aa46a0b7-d15b-4681-99d6-ba532e0e4599">
<br>
<br>
<br>

# URL
https://serve-l6h3.onrender.com  
ゲストログインで機能が利用できます。(ログインページに記載)  
起動時に1分程度かかる場合があります。
<br>

#### イメージ動画
https://www.youtube.com/embed/mV9DD2141Ps
<br>
<br>
<br>

# 使用技術・機能一覧

### 使用技術
<br>

#### フロントエンド
* HTML
* CSS(SCSS)
* JavaScript
* jQuery
* Bootstrap

#### バックエンド
* Ruby 3.1.4
* Ruby on Rails 7.0.4
* PostgreSQL (データベース)
* Amazon S3 (画像アップロード)

#### インフラ
* Mailgun (メール送信)
* render<br>
現在デプロイはマニュアルで行なっています。
<br>

#### その他
* Git / GitHub
* Visual Studio Code (エディタ)
<br>

#### 機能一覧

* ユーザー登録 / ログイン機能
* フォロー機能
* 投稿機能
* ブックマーク機能
* 問い合わせ機能 ( ActiveModel )
* メール送信機能
* 認証機能
* ページネーション機能 ( kaminari )
* アカウント有効化機能
* パスワード再設定機能
<br>

#### 今後採用したい技術・機能
* 検索機能
* MySQL
* Docker / Docker-compose  
開発環境およびテスト・本番環境構築の効率化のため
* AWS( Route53 / EC2 / RDS)
* Nginx  
独自ドメインや常時SSL化などインフラ関連知識を学ぶため
* RSpec
* CircleCI ( CI/CDパイプライン )  
テスト駆動開発を採用できるようになるため
<br>
<br>
<br>

## 工夫した点
<br>
ブックマーク機能はRailsチュートリアルのTurboを応用して実装しました。<br>
ブックマーク一覧表示は別途indexビュー等を用意せず、投稿一覧表示と同じ形式でマイページに表示できるようにしました。<br>
BootstrapのTabでページ内の表示を切り替え、パーシャルでページ遷移を行わずに一覧表示できるように工夫しました。<br>
投稿一覧ページでのブックマークは、一部がうまく機能しなかったため、投稿詳細ページからのみ可能としています。<br>
今後の課題は一覧ページからのブックマーク機能の実装です。
<br>
<br>
<br>

## 苦労した点
<br>
問い合わせページの実装ではデータベースに保存をしない「ActiveModel」を採用しました。<br>
またアクション名を任意にすることで、ビューの表示をわかりやすくしました。<br>
データベースに保存をしないため、アクションやビューでの引数の渡し方、form_withの記述エラーに苦労しました。<br>
調べて解決する力が高まり、理解もより一層深まりました。
<br>
<br>
<br>

## 制作背景・目的
<br>
自分が自宅でコーヒを飲むことが多く、今までに飲んだコーヒ豆をわかりやすく記録したいと思ったこと。<br>
さらに他の人がどんな豆を飲んでいるのか知りたい、同じ思いの人いるはずだと思い、作成に至りました。<br>
新たなコミュニティの作成が大きな目的です。