class HomeController < ApplicationController
  def show
    @products = Product.last(6).reverse
  end
end
