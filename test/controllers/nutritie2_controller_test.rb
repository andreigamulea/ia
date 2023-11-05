require "test_helper"

class Nutritie2ControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get nutritie2_index_url
    assert_response :success
  end
end
