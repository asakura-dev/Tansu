# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  product_id :integer
#  user_id    :integer
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class Comment < ActiveRecord::Base
  validates :content, length: {maximum: 1024}, presence: true
  belongs_to :product
  belongs_to :user

end
