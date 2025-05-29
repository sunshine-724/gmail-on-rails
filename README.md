# README

* Ruby version
ruby 3.4.3 (2025-04-14 revision d0b7e5b6a0) +PRISM [arm64-darwin24]

# Gmail Rails App

Gmail API を使ってメールの取得・表示・送信ができる Ruby on Rails アプリです。

## 機能
- Gmail 認証（OAuth）
- メール一覧表示
- メール本文表示
- メール送信（季節の挨拶付き）

## 使用技術
- Ruby on Rails
- Gmail API
- JavaScript（Importmap）

## セットアップ方法
1. `bundle install`
2. `rails db:setup`
3. Google Cloud Console で OAuth クライアントを作成
4. `.env` に認証情報を設定
