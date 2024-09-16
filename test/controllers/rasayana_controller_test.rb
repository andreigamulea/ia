require "test_helper"

class RasayanaControllerTest < ActionDispatch::IntegrationTest
  test "should get modul1" do
    get rasayana_modul1_url
    assert_response :success
  end
end
