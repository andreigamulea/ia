require "test_helper"

class VajikaranaControllerTest < ActionDispatch::IntegrationTest
  test "should get modul1" do
    get vajikarana_modul1_url
    assert_response :success
  end
end
