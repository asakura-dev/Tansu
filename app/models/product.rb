# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string(255)      default(""), not null
#  description :text
#  image       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#
require 'csv'
class Product < ActiveRecord::Base
  validates :name, length: {maximum: 96}, presence: true
  validates :description, length: {maximum: 2048}
  has_many :lendings, ->{order ("updated_at DESC")}, dependent: :destroy
  has_many :comments, ->{order ("updated_at ASC")}, dependent: :destroy
  #スコープの追加
  scope :unreturned, -> { joins(:lendings).merge(Lending.unreturned) }
  mount_uploader :image, ImageUploader
  # タグが管理できるようにする
  acts_as_taggable
  after_create :slack_notify_new_product

  def self.ransackable_attributes auth_object = nil
    %w(name description)
  end

  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      attrs = row.to_hash.slice("name","description")
      product = Product.new(attrs)
      product.save!
    end
  end
  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |model|
        csv << model.attributes.values_at(*column_names)
      end
    end
  end
  # フォームでbase64_imageというフォーム部品を表示させるために必要
  def base64_image
    return @base64_image
  end
  def base64_image=(file)
    @base64_image = file
  end
  
  # 貸出可能 or 貸出中かを返す
  def status
    if self.lendable?
      "returned"
    else
      "unreturned"
    end
  end
  
  # この備品の累計貸出回数
  def count
    self.lendings.length
  end

  # 借りれるかどうか
  def lendable?
    if latest_lending && latest_lending.status == "unreturned"
      # 借りれない
      false
    else
      # 借りれる
      true
    end
  end

  def lending_user
    latest_lending.user
  end

  def overdue?
    latest_lending.overdue?
  end

  def lending_date
    latest_lending.created_at.to_date
  end


  def deadline
    latest_lending.deadline
  end

  def latest_lending
    if self.lendings.first
      self.lendings.first
    else
      nil
    end
  end
  def slack_notify_new_product
    setting = SlackSetting.instance
    # slack通知が有効でない時，備品の追加を通知しない設定の時は通知しない
    if setting.notify_enable != true || setting.notify_new_product != true
      return
    end
    notifier = Slack::Notifier.new(setting.notify_webhook_url)
    if self.name.length > 40
      name = self.name[0,40] + "…"
    else
      name = self.name
    end
    message = "【新しい備品】「#{name}」 "
    option = {
      color: "good",
      text: message
    }
    notifier.ping "", attachments: [option]
  end
end
