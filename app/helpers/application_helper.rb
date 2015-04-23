# -*- coding: utf-8 -*-
module ApplicationHelper
  def member
    authority = current_user.authority
    if ["owner","manager","member"].include?(authority)
      true
    else
      redirect_to root_path, alert: '権限がありません(参加承認されている必要があります．オーナーに承認してもらってください)'
    end
  end
  def owner_or_manager
    authority = current_user.authority
    if ["owner","manager"].include?(authority)
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
  def product_status(status)
    case status
      when "returned"; "貸出可能"
      when "unreturned"; "貸出中"
    end
  end
end
