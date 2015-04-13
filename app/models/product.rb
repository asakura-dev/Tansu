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

class Product < ActiveRecord::Base
  validates :name, length: {maximum: 96}, presence: true
  validates :description, length: {maximum: 2000}

end
