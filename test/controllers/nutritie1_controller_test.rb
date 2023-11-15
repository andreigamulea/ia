require "test_helper"

class Nutritie1ControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get nutritie1_index_url
    assert_response :success
  end
end
