require "test_helper"

class CursurisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cursuri = cursuris(:one)
  end

  test "should get index" do
    get cursuris_url
    assert_response :success
  end

  test "should get new" do
    get new_cursuri_url
    assert_response :success
  end

  test "should create cursuri" do
    assert_difference("Cursuri.count") do
      post cursuris_url, params: { cursuri: { datainceput: @cursuri.datainceput, datasfarsit: @cursuri.datasfarsit, numecurs: @cursuri.numecurs, user_id: @cursuri.user_id } }
    end

    assert_redirected_to cursuri_url(Cursuri.last)
  end

  test "should show cursuri" do
    get cursuri_url(@cursuri)
    assert_response :success
  end

  test "should get edit" do
    get edit_cursuri_url(@cursuri)
    assert_response :success
  end

  test "should update cursuri" do
    patch cursuri_url(@cursuri), params: { cursuri: { datainceput: @cursuri.datainceput, datasfarsit: @cursuri.datasfarsit, numecurs: @cursuri.numecurs, user_id: @cursuri.user_id } }
    assert_redirected_to cursuri_url(@cursuri)
  end

  test "should destroy cursuri" do
    assert_difference("Cursuri.count", -1) do
      delete cursuri_url(@cursuri)
    end

    assert_redirected_to cursuris_url
  end
end
