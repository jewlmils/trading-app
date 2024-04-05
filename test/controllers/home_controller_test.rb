require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get landing" do
    get home_landing_url
    assert_response :success
  end

  test "should get trader" do
    get home_trader_url
    assert_response :success
  end

  test "should get admin" do
    get home_admin_url
    assert_response :success
  end
end
