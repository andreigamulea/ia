require "test_helper"

class ProdusControllerTest < ActionDispatch::IntegrationTest
  setup do
    @produ = produs(:one)
  end

  test "should get index" do
    get produs_url
    assert_response :success
  end

  test "should get new" do
    get new_produ_url
    assert_response :success
  end

  test "should create produ" do
    assert_difference("Produ.count") do
      post produs_url, params: { produ: { curslegatura: @produ.curslegatura, detalii: @produ.detalii, info: @produ.info, nume: @produ.nume, pret: @produ.pret, valabilitatezile: @produ.valabilitatezile } }
    end

    assert_redirected_to produ_url(Produ.last)
  end

  test "should show produ" do
    get produ_url(@produ)
    assert_response :success
  end

  test "should get edit" do
    get edit_produ_url(@produ)
    assert_response :success
  end

  test "should update produ" do
    patch produ_url(@produ), params: { produ: { curslegatura: @produ.curslegatura, detalii: @produ.detalii, info: @produ.info, nume: @produ.nume, pret: @produ.pret, valabilitatezile: @produ.valabilitatezile } }
    assert_redirected_to produ_url(@produ)
  end

  test "should destroy produ" do
    assert_difference("Produ.count", -1) do
      delete produ_url(@produ)
    end

    assert_redirected_to produs_url
  end
end
