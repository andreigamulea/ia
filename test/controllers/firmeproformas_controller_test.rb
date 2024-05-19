require "test_helper"

class FirmeproformasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @firmeproforma = firmeproformas(:one)
  end

  test "should get index" do
    get firmeproformas_url
    assert_response :success
  end

  test "should get new" do
    get new_firmeproforma_url
    assert_response :success
  end

  test "should create firmeproforma" do
    assert_difference("Firmeproforma.count") do
      post firmeproformas_url, params: { firmeproforma: { adresa: @firmeproforma.adresa, banca: @firmeproforma.banca, cod: @firmeproforma.cod, cont: @firmeproforma.cont, cui: @firmeproforma.cui, nrinceput: @firmeproforma.nrinceput, nume_institutie: @firmeproforma.nume_institutie, rc: @firmeproforma.rc, serie: @firmeproforma.serie, tva: @firmeproforma.tva } }
    end

    assert_redirected_to firmeproforma_url(Firmeproforma.last)
  end

  test "should show firmeproforma" do
    get firmeproforma_url(@firmeproforma)
    assert_response :success
  end

  test "should get edit" do
    get edit_firmeproforma_url(@firmeproforma)
    assert_response :success
  end

  test "should update firmeproforma" do
    patch firmeproforma_url(@firmeproforma), params: { firmeproforma: { adresa: @firmeproforma.adresa, banca: @firmeproforma.banca, cod: @firmeproforma.cod, cont: @firmeproforma.cont, cui: @firmeproforma.cui, nrinceput: @firmeproforma.nrinceput, nume_institutie: @firmeproforma.nume_institutie, rc: @firmeproforma.rc, serie: @firmeproforma.serie, tva: @firmeproforma.tva } }
    assert_redirected_to firmeproforma_url(@firmeproforma)
  end

  test "should destroy firmeproforma" do
    assert_difference("Firmeproforma.count", -1) do
      delete firmeproforma_url(@firmeproforma)
    end

    assert_redirected_to firmeproformas_url
  end
end
