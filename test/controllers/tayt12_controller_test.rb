require "test_helper"

class Tayt12ControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tayt12_index_url
    assert_response :success
  end
end
