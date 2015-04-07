# -*- coding: utf-8 -*-
module Admin
  module Member
    class AuthoritiesController < ApplicationController
      before_action :authenticate_user!
      before_action :owner, only: [:show, :update]
      def show
        @members = User.where(authority: ['owner','manager','member'])
      end
      def update
        @params = authority_update_params
        if @user = User.find(@params["user_id"])
          # 自分自身の権限は直接更新させない
          if @user != current_user
            if ["member","manager"].include?(@params["authority"])
              @user.authority = @params["authority"]
              @user.save
              render "update", :formats => [:json], :handlers => [:jbuilder]
            elsif @params["authority"] == "owner"
              User.transaction do
                current_user.authority = "manager"
                current_user.save
                @user.authority = "owner"
                @user.save
              end
              flash[:notice] = 'オーナー権限を移譲しました．'
              render js: "window.location = '/'"
            end
          end
        end
      end
    end
  end
end
