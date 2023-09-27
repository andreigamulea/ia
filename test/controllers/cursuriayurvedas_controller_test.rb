require "test_helper"

class CursuriayurvedasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cursuriayurveda = cursuriayurvedas(:one)
  end

  test "should get index" do
    get cursuriayurvedas_url
    assert_response :success
  end

  test "should get new" do
    get new_cursuriayurveda_url
    assert_response :success
  end

  test "should create cursuriayurveda" do
    assert_difference("Cursuriayurveda.count") do
      post cursuriayurvedas_url, params: { cursuriayurveda: { grupa: @cursuriayurveda.grupa } }
    end

    assert_redirected_to cursuriayurveda_url(Cursuriayurveda.last)
  end

  test "should show cursuriayurveda" do
    get cursuriayurveda_url(@cursuriayurveda)
    assert_response :success
  end

  test "should get edit" do
    get edit_cursuriayurveda_url(@cursuriayurveda)
    assert_response :success
  end

  test "should update cursuriayurveda" do
    patch cursuriayurveda_url(@cursuriayurveda), params: { cursuriayurveda: { grupa: @cursuriayurveda.grupa } }
    assert_redirected_to cursuriayurveda_url(@cursuriayurveda)
  end

  test "should destroy cursuriayurveda" do
    assert_difference("Cursuriayurveda.count", -1) do
      delete cursuriayurveda_url(@cursuriayurveda)
    end

    assert_redirected_to cursuriayurvedas_url
  end
end
