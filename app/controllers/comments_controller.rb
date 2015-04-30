# -*- coding: utf-8 -*-
class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :member
  before_action :correct_user , :only => [:destroy]
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      @status = "success"
      @message = "コメントを投稿しました"
      render "create", :formats => [:json], :handlers => [:jbuilder]
    else
      render :json => {'status' => 'faild', 'message' => 'コメントの投稿に失敗しました'}
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.destroy
      render :json => {'status' => 'success','message' => 'コメントを削除しました'}
    else
      render :json => {'status' => 'faild','message' => 'コメントの削除に失敗しました'}
    end
  end
  private
  def comment_params
    params[:comment][:user_id] = current_user.id
    params.require(:comment).permit(:content, :product_id, :user_id)
  end  
  def correct_user
    if Comment.find(params[:id]).user_id == current_user
      true
    elsif owner_or_manager
      true
    else
      false
    end
  end
end
