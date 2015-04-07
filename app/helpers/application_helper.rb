# -*- coding: utf-8 -*-
module ApplicationHelper
  def owner_or_manager
    authority = current_user.authority
    if authority == "owner" || authority == "manager"
      true
    else
      redirect_to root_path, alert: '権限がありません(オーナーか管理者権限が必要です)'
    end
  end
  def owner
    authority = current_user.authority
    if authority == "owner"
      true
    else
      redirect_to root_path, alert: '権限がありません(オーナー権限が必要です)'
    end
  end

  def authority_update_params
        params.require(:user).permit(:user_id, :authority)
  end
end
