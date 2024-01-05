require "test_helper"

class Nutritie4ControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get nutritie4_index_url
    assert_response :success
  end
end
