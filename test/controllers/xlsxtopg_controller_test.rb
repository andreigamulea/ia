require "test_helper"

class XlsxtopgControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get xlsxtopg_index_url
    assert_response :success
  end
end
