# -*- coding: utf-8 -*-
class ProductsController < ApplicationController
  include CarrierwaveBase64Uploader
  def index
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to new_products_path, notice: "備品を追加しました"
    else
      render 'new'
    end
  end

  def show
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
    unless base64_image.nil? || base64_image.empty?
      params[:product][:image] = base64_conversion(base64_image)
    end
    params.require(:product).permit(:name, :description, :image)
  end
end
