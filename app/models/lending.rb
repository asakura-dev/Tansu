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
end
