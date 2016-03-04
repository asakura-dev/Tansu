# -*- coding: utf-8 -*-
class ProductsController < ApplicationController
  include CarrierwaveBase64Uploader
  before_action :authenticate_user!
  before_action :member
  before_action :owner_or_manager, :only => [:admin_index, :new, :create, :edit, :update, :delete_image, :destroy, :import, :admin_lendings]
  def index
    tag = params["tag"]
    query = params["q"]
    if !tag && !query
      @heading = "新しい備品"
      @products = Product.order("created_at DESC").paginate(page: params[:page], :per_page => 10)
    elsif tag
      @heading = "タグ \"#{tag}\" を持つ備品"
      @products = Product.tagged_with(tag).paginate(page: params[:page], :per_page => 10)
    else
      @heading = "\"#{params['q']['name_or_description_cont']}\" の検索結果"
      @q = Product.search(query)
      @products = @q.result(distinct: true).paginate(page: params[:page], :per_page => 10)
    end
    respond_to do |format|
      format.html
      format.csv { send_data Product.to_csv }
    end
  end
  def admin_index
    @products = Product.order("created_at DESC").paginate(page: params[:page], :per_page => 10)
  end

  def admin_lendings
    @products = Product.order("created_at DESC").paginate(page: params[:page], :per_page => 10).unreturned
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
    expires_now
    @product = Product.find(params[:id])
    @comments = @product.comments
    gon.jbuilder
    gon.authority = current_user.authority
    gon.user_id = current_user.id
    gon.tags = @product.tag_list
    gon.tags_path = request.path_info + '/tags'
    gon.product_id = @product.id
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

  def import
    Product.import(params[:file])
    redirect_to admin_products_path, notice: "備品をインポートしました"
  end
  private
  def product_params
    base64_image = params[:product][:base64_image]
    # base64エンコードの画像が含まれていたら，画像に変換してparamに追加
    unless base64_image.nil? || base64_image.empty?
      params[:product][:image] = base64_conversion(base64_image)
    end
    params.require(:product).permit(:name, :description, :image,:url)
  end
end
