# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
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
end
