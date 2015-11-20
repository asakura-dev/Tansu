class LendingsController < ApplicationController
  before_action :authenticate_user!
  before_action :member
  def index
    tag = params["tag"]
    query = params["q"]
    if !tag && !query
      @heading = "貸出中の物品"
      @products = Product.order("created_at DESC").paginate(page: params[:page], :per_page => 10).unreturned
    elsif tag
      @heading = "タグ \"#{tag}\" を持つ備品"
      @products = Product.tagged_with(tag).paginate(page: params[:page], :per_page => 10)
    else
      @heading = "\"#{params['q']['name_or_description_cont']}\" の検索結果"
      @q = Product.search(query)
      @products = @q.result(distinct: true).paginate(page: params[:page], :per_page => 10)
    end
  end
end