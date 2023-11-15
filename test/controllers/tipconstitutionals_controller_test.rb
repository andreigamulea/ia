require "test_helper"

class TipconstitutionalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipconstitutional = tipconstitutionals(:one)
  end

  test "should get index" do
    get tipconstitutionals_url
    assert_response :success
  end

  test "should get new" do
    get new_tipconstitutional_url
    assert_response :success
  end

  test "should create tipconstitutional" do
    assert_difference("Tipconstitutional.count") do
      post tipconstitutionals_url, params: { tipconstitutional: { caracteristica: @tipconstitutional.caracteristica, nr: @tipconstitutional.nr, nrtip: @tipconstitutional.nrtip, tip: @tipconstitutional.tip } }
    end

    assert_redirected_to tipconstitutional_url(Tipconstitutional.last)
  end

  test "should show tipconstitutional" do
    get tipconstitutional_url(@tipconstitutional)
    assert_response :success
  end

  test "should get edit" do
    get edit_tipconstitutional_url(@tipconstitutional)
    assert_response :success
  end

  test "should update tipconstitutional" do
    patch tipconstitutional_url(@tipconstitutional), params: { tipconstitutional: { caracteristica: @tipconstitutional.caracteristica, nr: @tipconstitutional.nr, nrtip: @tipconstitutional.nrtip, tip: @tipconstitutional.tip } }
    assert_redirected_to tipconstitutional_url(@tipconstitutional)
  end

  test "should destroy tipconstitutional" do
    assert_difference("Tipconstitutional.count", -1) do
      delete tipconstitutional_url(@tipconstitutional)
    end

    assert_redirected_to tipconstitutionals_url
  end
end
