require "test_helper"

class ModulecursurisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @modulecursuri = modulecursuris(:one)
  end

  test "should get index" do
    get modulecursuris_url
    assert_response :success
  end

  test "should get new" do
    get new_modulecursuri_url
    assert_response :success
  end

  test "should create modulecursuri" do
    assert_difference("Modulecursuri.count") do
      post modulecursuris_url, params: { modulecursuri: { nume: @modulecursuri.nume } }
    end

    assert_redirected_to modulecursuri_url(Modulecursuri.last)
  end

  test "should show modulecursuri" do
    get modulecursuri_url(@modulecursuri)
    assert_response :success
  end

  test "should get edit" do
    get edit_modulecursuri_url(@modulecursuri)
    assert_response :success
  end

  test "should update modulecursuri" do
    patch modulecursuri_url(@modulecursuri), params: { modulecursuri: { nume: @modulecursuri.nume } }
    assert_redirected_to modulecursuri_url(@modulecursuri)
  end

  test "should destroy modulecursuri" do
    assert_difference("Modulecursuri.count", -1) do
      delete modulecursuri_url(@modulecursuri)
    end

    assert_redirected_to modulecursuris_url
  end
end
