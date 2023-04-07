require "test_helper"

class UseriiControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get userii_index_url
    assert_response :success
  end
end
