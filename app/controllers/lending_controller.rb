# -*- coding: utf-8 -*-
class LendingController < ApplicationController
  before_action :authenticate_user!
  before_action :member
  before_action :correct_user , only: :update
  
  def create
    @product = Product.find(params[:product_id])
    faild_message = '貸出処理に失敗しました。再度手続きをお願いします。'
    if @product.lendable?
      user_id = current_user.id
      deadline = Time.now + 1.week
      lending = Lending.new(user_id: user_id, product_id: @product.id, deadline: deadline, status: "unreturned")
      if lending.save
        redirect_to product_path(@product), notice: "貸し出されました"
      else
        redirect_to product_path(@product), alert: faild_message
      end
    else
      redirect_to product_path(@product), alert: faild_message
    end
  end
  def update
    lending = Lending.find(params[:id])
    new_status = params[:status]
    if ["returned"].include?(new_status)
      lending.status = params[:status]
      if lending.save
        redirect_to :back, notice: '返却しました'
      else
        redirect_to :back, alert: '返却処理に失敗しました。再度手続きをお願いします。'
      end
    end
  end
  private
  def correct_user
    lending = Lending.find(params[:id])
    if lending && lending.user == current_user
      true
    else
      false
    end
  end
end
