require "test_helper"

class TraditiaAyurvedicaControllerTest < ActionDispatch::IntegrationTest
  test "should get amnaya" do
    get traditia_ayurvedica_amnaya_url
    assert_response :success
  end
end
