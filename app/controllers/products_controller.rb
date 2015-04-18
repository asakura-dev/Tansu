# -*- coding: utf-8 -*-
class ProductsController < ApplicationController
  include CarrierwaveBase64Uploader
  def index
    @products = Product.order("created_at DESC").paginate(page: params[:page], :per_page => 10)
  end
  def admin_index
    @products = Product.order("created_at DESC").paginate(page: params[:page], :per_page => 10)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to new_product_path, notice: "備品を追加しました"
    else
      render 'new'
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to product_path(@product)
    else
      render 'edit'
    end
  end
  def delete_image
    product = Product.find(params[:id])
    product.remove_image!
    if product.save
      render :json => {'status' => 'success'}
    else
      render :json => {'status' => 'faild'}
    end
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy
    redirect_to admin_products_path, notice: "備品を削除しました"
  end
  private
  def product_params
    base64_image = params[:product][:base64_image]
    # base64エンコードの画像が含まれていたら，画像に変換してparamに追加
    unless base64_image.nil? || base64_image.empty?
      params[:product][:image] = base64_conversion(base64_image)
    end
    params.require(:product).permit(:name, :description, :image)
  end
end
