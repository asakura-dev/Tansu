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
    SlackNotificationJob.perform_later("lent_product", self.id)
  end
  def slack_notify_returned
    SlackNotificationJob.perform_later("returned_product", self.id)
  end
end
