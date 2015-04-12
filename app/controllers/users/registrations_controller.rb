# -*- coding: utf-8 -*-
class Users::RegistrationsController < Devise::RegistrationsController
  include CarrierwaveBase64Uploader
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
  def delete_icon()
    if user_signed_in?
      current_user.remove_image!
      if current_user.save
        render :json => {'status' => 'success'}
      else
        render :json => {'status' => 'failed'}
      end
    end
  end
end
