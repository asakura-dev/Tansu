# -*- coding: utf-8 -*-
class SlackNotificationJob < ActiveJob::Base
  queue_as :default
  
  def perform(notify_type, id)
    setting = SlackSetting.instance
    # slack通知が有効でない時処理を中断
    if setting.notify_enable != true
      return
    end
    case notify_type
      when "new_product" then
      slack_notify_new_product(id]) if setting.notify_new_product == true

      when "lent_product" then
      slack_notify_lent_product(id) if setting.notify_lent_product == true

      when "returned_product" then
      slack_notify_returned_product(id) if setting.notify_returned_product == true
    end
  end

  def slack_notify_new_product(product_id)
    product = Product.find(product_id)
    message = "【新しい備品】「%s」"
    color = "good"
    args = [product.name]
    slack_notify(color,message,args)
  end

  def slack_notify_lent_product(lending_id)
    lending = Lending.find(lending_id)
    message = "【貸出】%sさんが「%s」を借りました"
    color = "#ddd"
    args = [lending.user.name, lending.product.name]
    slack_notify(color,message,args)
  end

  def slack_notify_returned_product(lending_id)
    lending = Lending.find(lending_id)
    message = "【返却】%sさんが「%s」を返却しました"
    color = "#ddd"
    args = [lending.user.name, lending.product.name]
    slack_notify(color, message, args)
  end

  # slackに投稿する
  # color: 投稿時の左側のボーダ色
  # message: 投稿するメッセージ 
  # 形式は，"【%d】%dが投稿されました" など
  # args: メッセージに埋め込む引数の配列
  def slack_notify(color,message,args)
    setting = SlackSetting.instance
    notifier = Slack::Notifier.new(setting.notify_webhook_url)
    # メッセージに埋め込む引数を加工
    # 文字列 -> 40文字以内に省略，エスケープ処理
    # 数字 -> 文字列に変換
    args.map!{|arg|
      if arg.is_a?(String)
        if arg.length > 40
          arg = arg[0,40] + "…"
        else
          arg
        end
        notifier.escape(arg)
      elsif arg.is_a?(Numeric)
        arg = arg.to_s
      end
    }
    # メッセージに引数を埋め込む
    message = message%(args)
    # slackの投稿オプション
    option = {
      color: color,
      text: message
    }
    # 送信
    notifier.ping "", attachments: [option]
  end
end

