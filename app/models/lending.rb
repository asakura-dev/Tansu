# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: lendings
#
#  id         :integer          not null, primary key
#  product_id :integer
#  user_id    :integer
#  deadline   :date
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Lending < ActiveRecord::Base
  validates :status, presence: true, :inclusion => ['unreturned','returned']
  belongs_to :product
  belongs_to :user
  scope :unreturned, -> { where status: "unreturned" }
  after_create :slack_notify_lent
  after_update :slack_notify_returned
  def self.count(option)
    if option == "all"
      Lending.all().length
    elsif option == "current_month"
      t = Time.now
      from = t.beginning_of_month
      to = from.next_month
      Lending.where(created_at: from...to).length
    elsif option == "last_month"
      t = Time.now.last_month
      from = t.beginning_of_month
      to = from.next_month
      Lending.where(created_at: from...to).length
    end
  end
  
  def overdue?
    deadline < Date.today
  end
  def slack_notify_lent
    setting = SlackSetting.instance
    # slack通知が有効でない時，貸出を通知しない設定の時は通知しない
    if setting.notify_enable != true || setting.notify_lent_product != true
      return
    end
    notifier = Slack::Notifier.new(setting.notify_webhook_url)
    if self.product.name.length > 40
      name = self.product.name[0,40] + "…"
    else
      name = self.product.name
    end
    name = notifier.escape(name)
    user = notifier.escape(self.user.name)
    message = "【貸出】#{user}さんが「#{name}」を借りました "
    option = {
      color: "#ccc",
      text: message
    }
    notifier.ping "", attachments: [option]
  end
  def slack_notify_returned
    setting = SlackSetting.instance
    # slack通知が有効でない時，返却を通知しない設定の時は通知しない
    if setting.notify_enable != true || setting.notify_returned_product != true
      return
    end
    notifier = Slack::Notifier.new(setting.notify_webhook_url)
    if self.product.name.length > 40
      name = self.product.name[0,40] + "…"
    else
      name = self.product.name
    end
    name = notifier.escape(name)
    user = notifier.escape(self.user.name)
    message = "【返却】#{user}さんが「#{name}」を返却しました "
    option = {
      color: "#ccc",
      text: message
    }
    notifier.ping "", attachments: [option]
  end
end
