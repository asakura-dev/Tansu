# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  provider               :string(255)      default(""), not null
#  uid                    :string(255)      default(""), not null
#  name                   :string(255)
#  authority              :string(255)      default("pending"), not null
#  image                  :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
  omniauth_providers: [:twitter, :github]
  mount_uploader :image, ImageUploader
  validates :name, length: { maximum: 48 }, presence: true
  validates :authority, presence: true, :inclusion => ['owner', 'manager', 'member', 'pending', 'reject']
  has_many :lendings
  
  before_save :when_confirmed

  def unreturned_lendings
    self.lendings.select{|lending|
      lending.status == "unreturned"
    }
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.new(name: auth.info.nickname,
                      provider: auth.provider,
                      uid: auth.uid,
                      email: User.create_unique_email,
                      password: Devise.friendly_token[0,20]
                      )
      # 外部連携ログインでは，メールでのアカウントの有効化をスキップさせる
      user.skip_confirmation!
      user.set_autority
      user.save
    end
    user
  end

  def self.find_for_github_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    puts auth
    unless user
      user = User.new(name: auth.info.nickname,
                      provider: auth.provider,
                      uid: auth.uid,
                      email: User.create_unique_email,
                      password: Devise.friendly_token[0,20]
                      )
      user.skip_confirmation!
      user.set_autority
      user.save
    end
    user
  end

  def self.create_unique_string
    SecureRandom.uuid
  end

  def self.create_unique_email
    User.create_unique_string + "@example.com"
  end

  def set_autority
    # 一番最初に有効化された時，オーナー権限を付与
    if User.where("confirmed_at not ?", nil).length == 0
      self.authority = "owner"
    end
  end

  def base64_image
    return @base64_image
  end
  def base64_image=(file)
    @base64_image = file
  end

  def owner?
    self.authority == "owner"
  end
  def owner_or_manager?
    self.authority == "owner" || self.authority == "manager"
  end
  def member?
    if self.owner_or_manager? || self.authority == "member"
      true
    else
      false
    end
  end
  private 
  def when_confirmed
    # アカウントが有効化された時
    if self.confirmed_at_changed?
      self.set_autority
    end
    true
  end
  
end
