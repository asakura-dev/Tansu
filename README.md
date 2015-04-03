# Gruppi-Goods 
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
./config/initializers/devise.rb

config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

のメールアドレス部分を好みに変更(メールを送信するアドレスが良いです)
この部分に指定されたメールアドレスが，登録メールのデフォルトの返信先になります．