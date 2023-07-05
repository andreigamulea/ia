require "test_helper"

class ProdsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @prod = prods(:one)
  end

  test "should get index" do
    get prods_url
    assert_response :success
  end

  test "should get new" do
    get new_prod_url
    assert_response :success
  end

  test "should create prod" do
    assert_difference("Prod.count") do
      post prods_url, params: { prod: { curslegatura: @prod.curslegatura, detalii: @prod.detalii, info: @prod.info, nume: @prod.nume, pret: @prod.pret, valabilitatezile: @prod.valabilitatezile } }
    end

    assert_redirected_to prod_url(Prod.last)
  end

  test "should show prod" do
    get prod_url(@prod)
    assert_response :success
  end

  test "should get edit" do
    get edit_prod_url(@prod)
    assert_response :success
  end

  test "should update prod" do
    patch prod_url(@prod), params: { prod: { curslegatura: @prod.curslegatura, detalii: @prod.detalii, info: @prod.info, nume: @prod.nume, pret: @prod.pret, valabilitatezile: @prod.valabilitatezile } }
    assert_redirected_to prod_url(@prod)
  end

  test "should destroy prod" do
    assert_difference("Prod.count", -1) do
      delete prod_url(@prod)
    end

    assert_redirected_to prods_url
  end
end
