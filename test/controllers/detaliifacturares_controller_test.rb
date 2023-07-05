require "test_helper"

class DetaliifacturaresControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get detaliifacturares_create_url
    assert_response :success
  end
end
