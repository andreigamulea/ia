require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_index_url
    assert_response :success
  end

  test "should get edit" do
    get admin_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_update_url
    assert_response :success
  end
end
