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
    end
  end
end
