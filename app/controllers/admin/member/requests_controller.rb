# -*- coding: utf-8 -*-
module Admin
  module Member
    class RequestsController < ApplicationController
      before_action :authenticate_user!
      before_action :owner_or_manager, only: [:show, :update]
      def show
        @requesting_users = User.where("authority = 'pending'")
        @rejected_users = User.where("authority = 'reject'")
      end
      def update
        @params = authority_update_params
        p @params
        if @user = User.find(@params["user_id"])
          if ["member", "reject"].include?(@params["authority"])
            @user.authority = @params["authority"]
            if @user.save
              @user
              render "update", :formats => [:json], :handlers => [:jbuilder]
            else
              @user
              render "update", :formats => [:json], :handlers => [:jbuilder]
            end
          end
        end
      end

      private
      def owner_or_manager
        authority = current_user.authority
        if authority == "owner" || authority == "manager"
          true
        else
          redirect_to root_path, alert: '権限がありません'
        end
      end

      def authority_update_params
        params.require(:user).permit(:user_id, :authority)
      end
    end
  end
end
