# -*- coding: utf-8 -*-
class Users::RegistrationsController < Devise::RegistrationsController
  include CarrierwaveBase64Uploader
  def destroy
    if current_user.unreturned_lendings.length != 0
      redirect_to edit_user_registration_path, alert: "未返却の備品が存在するため退会できません"
    elsif current_user.owner?
      redirect_to edit_user_registration_path, alert: "オーナー権限を保持しているため退会できません。オーナー権限を移譲してから退会してください。"
    else
      super
    end
  end

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
