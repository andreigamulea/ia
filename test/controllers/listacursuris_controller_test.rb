require "test_helper"

class ListacursurisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @listacursuri = listacursuris(:one)
  end

  test "should get index" do
    get listacursuris_url
    assert_response :success
  end

  test "should get new" do
    get new_listacursuri_url
    assert_response :success
  end

  test "should create listacursuri" do
    assert_difference("Listacursuri.count") do
      post listacursuris_url, params: { listacursuri: { nume: @listacursuri.nume } }
    end

    assert_redirected_to listacursuri_url(Listacursuri.last)
  end

  test "should show listacursuri" do
    get listacursuri_url(@listacursuri)
    assert_response :success
  end

  test "should get edit" do
    get edit_listacursuri_url(@listacursuri)
    assert_response :success
  end

  test "should update listacursuri" do
    patch listacursuri_url(@listacursuri), params: { listacursuri: { nume: @listacursuri.nume } }
    assert_redirected_to listacursuri_url(@listacursuri)
  end

  test "should destroy listacursuri" do
    assert_difference("Listacursuri.count", -1) do
      delete listacursuri_url(@listacursuri)
    end

    assert_redirected_to listacursuris_url
  end
end
