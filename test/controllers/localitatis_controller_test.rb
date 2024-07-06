require "test_helper"

class LocalitatisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @localitati = localitatis(:one)
  end

  test "should get index" do
    get localitatis_url
    assert_response :success
  end

  test "should get new" do
    get new_localitati_url
    assert_response :success
  end

  test "should create localitati" do
    assert_difference("Localitati.count") do
      post localitatis_url, params: { localitati: { abr: @localitati.abr, cod: @localitati.cod, cod_vechi: @localitati.cod_vechi, denj: @localitati.denj, denumire: @localitati.denumire, judetid: @localitati.judetid } }
    end

    assert_redirected_to localitati_url(Localitati.last)
  end

  test "should show localitati" do
    get localitati_url(@localitati)
    assert_response :success
  end

  test "should get edit" do
    get edit_localitati_url(@localitati)
    assert_response :success
  end

  test "should update localitati" do
    patch localitati_url(@localitati), params: { localitati: { abr: @localitati.abr, cod: @localitati.cod, cod_vechi: @localitati.cod_vechi, denj: @localitati.denj, denumire: @localitati.denumire, judetid: @localitati.judetid } }
    assert_redirected_to localitati_url(@localitati)
  end

  test "should destroy localitati" do
    assert_difference("Localitati.count", -1) do
      delete localitati_url(@localitati)
    end

    assert_redirected_to localitatis_url
  end
end
