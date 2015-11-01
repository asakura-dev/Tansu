require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  test "should get admin_lendings" do
    get :admin_lendings
    assert_response :success
  end

end
