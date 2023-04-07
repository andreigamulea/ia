require "test_helper"

class GestionareUseriCursuriControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get gestionare_useri_cursuri_index_url
    assert_response :success
  end
end
