require "test_helper"

class PlantesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @plante = plantes(:one)
  end

  test "should get index" do
    get plantes_url
    assert_response :success
  end

  test "should get new" do
    get new_plante_url
    assert_response :success
  end

  test "should create plante" do
    assert_difference("Plante.count") do
      post plantes_url, params: { plante: { denbot: @plante.denbot, fam: @plante.fam, idp: @plante.idp, nume: @plante.nume, numeayu: @plante.numeayu, numesec: @plante.numesec, numesec2: @plante.numesec2, subt: @plante.subt, tip: @plante.tip } }
    end

    assert_redirected_to plante_url(Plante.last)
  end

  test "should show plante" do
    get plante_url(@plante)
    assert_response :success
  end

  test "should get edit" do
    get edit_plante_url(@plante)
    assert_response :success
  end

  test "should update plante" do
    patch plante_url(@plante), params: { plante: { denbot: @plante.denbot, fam: @plante.fam, idp: @plante.idp, nume: @plante.nume, numeayu: @plante.numeayu, numesec: @plante.numesec, numesec2: @plante.numesec2, subt: @plante.subt, tip: @plante.tip } }
    assert_redirected_to plante_url(@plante)
  end

  test "should destroy plante" do
    assert_difference("Plante.count", -1) do
      delete plante_url(@plante)
    end

    assert_redirected_to plantes_url
  end
end
