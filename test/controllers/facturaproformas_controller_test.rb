require "test_helper"

class FacturaproformasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @facturaproforma = facturaproformas(:one)
  end

  test "should get index" do
    get facturaproformas_url
    assert_response :success
  end

  test "should get new" do
    get new_facturaproforma_url
    assert_response :success
  end

  test "should create facturaproforma" do
    assert_difference("Facturaproforma.count") do
      post facturaproformas_url, params: { facturaproforma: { altedate: @facturaproforma.altedate, cantitate: @facturaproforma.cantitate, cod_firma: @facturaproforma.cod_firma, cod_postal: @facturaproforma.cod_postal, comanda_id: @facturaproforma.comanda_id, cui: @facturaproforma.cui, data_emiterii: @facturaproforma.data_emiterii, judet: @facturaproforma.judet, localitate: @facturaproforma.localitate, numar_adresa: @facturaproforma.numar_adresa, numar_comanda: @facturaproforma.numar_comanda, numar_factura: @facturaproforma.numar_factura, nume: @facturaproforma.nume, nume_companie: @facturaproforma.nume_companie, prenume: @facturaproforma.prenume, pret_unitar: @facturaproforma.pret_unitar, prod_id: @facturaproforma.prod_id, produs: @facturaproforma.produs, status: @facturaproforma.status, strada: @facturaproforma.strada, tara: @facturaproforma.tara, telefon: @facturaproforma.telefon, user_id: @facturaproforma.user_id, valoare_totala: @facturaproforma.valoare_totala, valoare_tva: @facturaproforma.valoare_tva } }
    end

    assert_redirected_to facturaproforma_url(Facturaproforma.last)
  end

  test "should show facturaproforma" do
    get facturaproforma_url(@facturaproforma)
    assert_response :success
  end

  test "should get edit" do
    get edit_facturaproforma_url(@facturaproforma)
    assert_response :success
  end

  test "should update facturaproforma" do
    patch facturaproforma_url(@facturaproforma), params: { facturaproforma: { altedate: @facturaproforma.altedate, cantitate: @facturaproforma.cantitate, cod_firma: @facturaproforma.cod_firma, cod_postal: @facturaproforma.cod_postal, comanda_id: @facturaproforma.comanda_id, cui: @facturaproforma.cui, data_emiterii: @facturaproforma.data_emiterii, judet: @facturaproforma.judet, localitate: @facturaproforma.localitate, numar_adresa: @facturaproforma.numar_adresa, numar_comanda: @facturaproforma.numar_comanda, numar_factura: @facturaproforma.numar_factura, nume: @facturaproforma.nume, nume_companie: @facturaproforma.nume_companie, prenume: @facturaproforma.prenume, pret_unitar: @facturaproforma.pret_unitar, prod_id: @facturaproforma.prod_id, produs: @facturaproforma.produs, status: @facturaproforma.status, strada: @facturaproforma.strada, tara: @facturaproforma.tara, telefon: @facturaproforma.telefon, user_id: @facturaproforma.user_id, valoare_totala: @facturaproforma.valoare_totala, valoare_tva: @facturaproforma.valoare_tva } }
    assert_redirected_to facturaproforma_url(@facturaproforma)
  end

  test "should destroy facturaproforma" do
    assert_difference("Facturaproforma.count", -1) do
      delete facturaproforma_url(@facturaproforma)
    end

    assert_redirected_to facturaproformas_url
  end
end
