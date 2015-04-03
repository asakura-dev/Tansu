# -*- coding: utf-8 -*-
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_paramaters, only:[:update]

  def build_resource(hash=nil)
    hash[:uid] = User.create_unique_string
    super
  end

  def update_resource(resource, params)
    if current_user.provider.empty?
      resource.update_with_password(params)
    else
      # 外部連携ログインでパスワードがないとき
      params.delete("current_password")
      params.delete("email")
      resource.update_without_password(params)
    end
  end

  private
  def configure_permitted_paramaters
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :email, :password, :password_confirmation, :current_password)
    end
  end
end
