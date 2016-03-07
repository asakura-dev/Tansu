# -*- coding: utf-8 -*-
module Admin
  module Settings
    class SlacksController < ApplicationController
      before_action :authenticate_user!
      before_action :owner_or_manager
      def show
        @setting = SlackSetting.instance
      end
      def update
        @setting = SlackSetting.instance
        @params = slack_settings_update_params
        @setting.notify_enable = to_boolean(@params[:enable])
        @setting.notify_webhook_url = @params[:webhook_url]
        @setting.notify_new_product = to_boolean(@params[:new_product])
        @setting.notify_lent_product = to_boolean(@params[:lent_product])
        @setting.notify_returned_product = to_boolean(@params[:returned_product])
        @setting.save
        redirect_to admin_settings_slack_path, notice: "設定を更新しました"
      end
      private
      def slack_settings_update_params
        params.require(:slack).permit(:enable, :webhook_url, :new_product, :lent_product, :returned_product)
      end
      def to_boolean(var)
        case var
        when true,'true',1,'1'
          return true
        when false, 'false',0,'0'
          return false
        end
      end
    end
  end
end
