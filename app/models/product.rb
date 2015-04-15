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

class Product < ActiveRecord::Base
  validates :name, length: {maximum: 96}, presence: true
  validates :description, length: {maximum: 2048}
  mount_uploader :image, ImageUploader
  # フォームでbase64_imageというフォーム部品を表示させるために必要
  def base64_image
    return @base64_image
  end
  def base64_image=(file)
    @base64_image = file
  end
end
