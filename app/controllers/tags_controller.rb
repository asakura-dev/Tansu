# -*- coding: utf-8 -*-
class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :member

  
  def create
    @product = Product.find(params[:product_id])
    tag_list = @product.tag_list
    # tagのバリデーションが上手くいかなかったのでコントローラに書いた...
    if params[:new_tag].length > 20
      render :json => {'status' => 'faild', 'message' => 'タグは20文字以内にしてください'}
    elsif tag_list.length > 19
      render :json => {'status' => 'faild', 'message' => 'タグは20個までしか登録できません'}
    elsif tag_list.include?(params[:new_tag])
      render :json => {'status' => 'faild', 'message' => '既に登録済みのタグです'}
    else
      @product.tag_list.add(params[:new_tag])
      if @product.save
        render :json => {'status' => 'success'}
      else
        render :json => {'status' => 'faild', 'message' => '登録に失敗しました'}
      end
    end
  end
  def destroy
    @product = Product.find(params[:product_id])
    before_tag_list = @product.tag_list.clone
    after_tag_list = @product.tag_list.remove(params[:tag])
    if (before_tag_list - after_tag_list) == [params[:tag]]
      if @product.save
        render :json => {'status' => 'success'}
      else
        render :json => {'status' => 'faild', 'message' => '削除に失敗しました'}
      end
    else
      render :json => {'status' => 'faild', 'message' => '存在しないタグです'}
    end
  end
end
