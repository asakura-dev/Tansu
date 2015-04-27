class HomeController < ApplicationController
  def show
    @products = Product.last(6).reverse
    @tags = ActsAsTaggableOn::Tag.most_used(20)
  end
end
