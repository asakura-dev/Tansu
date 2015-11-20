class HomeController < ApplicationController
  def show
    @products = Product.last(6).reverse
    @lendings = Product.unreturned.last(6).reverse
    @tags = ActsAsTaggableOn::Tag.most_used(20)
    @comments = Comment.last(3).reverse
  end
end
