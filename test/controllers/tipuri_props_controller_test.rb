require "test_helper"

class TipuriPropsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipuri_prop = tipuri_props(:one)
  end

  test "should get index" do
    get tipuri_props_url
    assert_response :success
  end

  test "should get new" do
    get new_tipuri_prop_url
    assert_response :success
  end

  test "should create tipuri_prop" do
    assert_difference("TipuriProp.count") do
      post tipuri_props_url, params: { tipuri_prop: { cp: @tipuri_prop.cp, explicatie: @tipuri_prop.explicatie, idxcp: @tipuri_prop.idxcp } }
    end

    assert_redirected_to tipuri_prop_url(TipuriProp.last)
  end

  test "should show tipuri_prop" do
    get tipuri_prop_url(@tipuri_prop)
    assert_response :success
  end

  test "should get edit" do
    get edit_tipuri_prop_url(@tipuri_prop)
    assert_response :success
  end

  test "should update tipuri_prop" do
    patch tipuri_prop_url(@tipuri_prop), params: { tipuri_prop: { cp: @tipuri_prop.cp, explicatie: @tipuri_prop.explicatie, idxcp: @tipuri_prop.idxcp } }
    assert_redirected_to tipuri_prop_url(@tipuri_prop)
  end

  test "should destroy tipuri_prop" do
    assert_difference("TipuriProp.count", -1) do
      delete tipuri_prop_url(@tipuri_prop)
    end

    assert_redirected_to tipuri_props_url
  end
end
