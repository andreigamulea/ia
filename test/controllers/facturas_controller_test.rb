require "test_helper"

class FacturasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @factura = facturas(:one)
  end

  test "should get index" do
    get facturas_url
    assert_response :success
  end

  test "should get new" do
    get new_factura_url
    assert_response :success
  end

  test "should create factura" do
    assert_difference("Factura.count") do
      post facturas_url, params: { factura: { cantitate: @factura.cantitate, cod_postal: @factura.cod_postal, comanda_id: @factura.comanda_id, cui: @factura.cui, data_emiterii: @factura.data_emiterii, judet: @factura.judet, localitate: @factura.localitate, numar: @factura.numar, numar_adresa: @factura.numar_adresa, numar_comanda: @factura.numar_comanda, nume: @factura.nume, nume_companie: @factura.nume_companie, prenume: @factura.prenume, pret_unitar: @factura.pret_unitar, produs: @factura.produs, strada: @factura.strada, tara: @factura.tara, user_id: @factura.user_id, valoare_totala: @factura.valoare_totala, valoare_tva: @factura.valoare_tva } }
    end

    assert_redirected_to factura_url(Factura.last)
  end

  test "should show factura" do
    get factura_url(@factura)
    assert_response :success
  end

  test "should get edit" do
    get edit_factura_url(@factura)
    assert_response :success
  end

  test "should update factura" do
    patch factura_url(@factura), params: { factura: { cantitate: @factura.cantitate, cod_postal: @factura.cod_postal, comanda_id: @factura.comanda_id, cui: @factura.cui, data_emiterii: @factura.data_emiterii, judet: @factura.judet, localitate: @factura.localitate, numar: @factura.numar, numar_adresa: @factura.numar_adresa, numar_comanda: @factura.numar_comanda, nume: @factura.nume, nume_companie: @factura.nume_companie, prenume: @factura.prenume, pret_unitar: @factura.pret_unitar, produs: @factura.produs, strada: @factura.strada, tara: @factura.tara, user_id: @factura.user_id, valoare_totala: @factura.valoare_totala, valoare_tva: @factura.valoare_tva } }
    assert_redirected_to factura_url(@factura)
  end

  test "should destroy factura" do
    assert_difference("Factura.count", -1) do
      delete factura_url(@factura)
    end

    assert_redirected_to facturas_url
  end
end
