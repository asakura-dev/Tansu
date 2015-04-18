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
  end

  def update
  end

  def destroy
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
