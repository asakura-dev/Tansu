# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include Jpmobile::ViewSelector
  include ApplicationHelper
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :view_selector_enabled?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) do |u|
      unless u[:base64_image].nil? || u[:base64_image].empty?
        # CarrierwaveBase64Uploaderモジュール参照
        u[:image] = base64_conversion(u[:base64_image]) 
      end
      u.permit(:name, :email, :password, :password_confirmation, :image,:current_password)
    end
  end
  def view_selector_enabled?
    if cookies[:view_selector].nil?
      cookies[:view_selector] = "enabled"
    end
    if cookies[:view_selector] == "disabled"
      disable_mobile_view!
    end
    true
  end
end
