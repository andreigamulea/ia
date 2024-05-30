require "test_helper"

class TabereControllerTest < ActionDispatch::IntegrationTest
  test "should get tayv24" do
    get tabere_tayv24_url
    assert_response :success
  end
end
