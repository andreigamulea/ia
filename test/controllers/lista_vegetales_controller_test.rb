require "test_helper"

class ListaVegetalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lista_vegetale = lista_vegetales(:one)
  end

  test "should get index" do
    get lista_vegetales_url
    assert_response :success
  end

  test "should get new" do
    get new_lista_vegetale_url
    assert_response :success
  end

  test "should create lista_vegetale" do
    assert_difference("ListaVegetale.count") do
      post lista_vegetales_url, params: { lista_vegetale: { mentiunirestrictii: @lista_vegetale.mentiunirestrictii, parteutilizata: @lista_vegetale.parteutilizata, sinonime: @lista_vegetale.sinonime, specie: @lista_vegetale.specie } }
    end

    assert_redirected_to lista_vegetale_url(ListaVegetale.last)
  end

  test "should show lista_vegetale" do
    get lista_vegetale_url(@lista_vegetale)
    assert_response :success
  end

  test "should get edit" do
    get edit_lista_vegetale_url(@lista_vegetale)
    assert_response :success
  end

  test "should update lista_vegetale" do
    patch lista_vegetale_url(@lista_vegetale), params: { lista_vegetale: { mentiunirestrictii: @lista_vegetale.mentiunirestrictii, parteutilizata: @lista_vegetale.parteutilizata, sinonime: @lista_vegetale.sinonime, specie: @lista_vegetale.specie } }
    assert_redirected_to lista_vegetale_url(@lista_vegetale)
  end

  test "should destroy lista_vegetale" do
    assert_difference("ListaVegetale.count", -1) do
      delete lista_vegetale_url(@lista_vegetale)
    end

    assert_redirected_to lista_vegetales_url
  end
end
