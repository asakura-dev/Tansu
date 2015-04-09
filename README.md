# Tansu
![動作画面](./screenshot.png)

備品管理サービス

## インストール
[Ruby - rbenv インストールから Bundler を使用した Rails のローカルインストールと起動まで - Qiita](http://qiita.com/egopro/items/aba12261c053eecd6d19)  
を参考に，
- rbenv
- ruby
- Bundler
- Ruby On Rails
をインストール

## 設定
### メール周り
```ruby
#./config/initializers/devise.rb  
config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'  
```
メールアドレス部分を好みに変更(メールを送信するアドレスが良いです)
この部分に指定されたメールアドレスが，登録メールのデフォルトの返信先になります．
```ruby
#./config/environments/development.rb および ./config/environments/production.rb の末尾あたり
  config.action_mailer.smtp_settings = {
    :address => ENV["SMTP_ADDRESS"],
    :port => ENV["SMTP_PORT"],
    :authentication => :plain,
    :user_name => ENV["SMTP_USER_NAME"],
    :password => ENV["SMTP_PASSWORD"]
  }
```
メールの送信に必要な情報を設定してください．

### Twiiterログイン
```ruby
#./config/initializers/devise.rb 230行目あたり  
config.omniauth :twitter, ENV["TWITTER_CONSUMER_KEY"], ENV["TWITTER_CONSUMER_SECRET"]
```
[Twitter Application Management](https://apps.twitter.com/)よりアプリを作成し，各キーを取得して設定してください．  
アプリ作成の際のCallback URLは "http://あなたのホスト名/auth/twitter/callback"にしてください．

### Githubログイン
```ruby
#./config/initializers/devise.rb 230行目あたり  
config.omniauth :github , ENV["GITHUB_CONSUMER_KEY"], ENV["GITHUB_CONSUMER_SECRET"],
  :callback_url => ENV["TANSU_URL"]+"/users/auth/github/callback"
```
[Authorized applications](https://github.com/settings/applications)より，アプリを作成し，各キーを取得して設定してください．  
アプリ作成の際のCallback URLは "http://あなたのホスト名/auth/github/callback"にしてください．  
TANSU_URLには，"http://あなたのホスト名"を設定してください．
