require "application_system_test_case"

class FacturasTest < ApplicationSystemTestCase
  setup do
    @factura = facturas(:one)
  end

  test "visiting the index" do
    visit facturas_url
    assert_selector "h1", text: "Facturas"
  end

  test "should create factura" do
    visit facturas_url
    click_on "New factura"

    fill_in "Cantitate", with: @factura.cantitate
    fill_in "Cod postal", with: @factura.cod_postal
    fill_in "Comanda", with: @factura.comanda_id
    fill_in "Cui", with: @factura.cui
    fill_in "Data emiterii", with: @factura.data_emiterii
    fill_in "Judet", with: @factura.judet
    fill_in "Localitate", with: @factura.localitate
    fill_in "Numar", with: @factura.numar
    fill_in "Numar adresa", with: @factura.numar_adresa
    fill_in "Numar comanda", with: @factura.numar_comanda
    fill_in "Nume", with: @factura.nume
    fill_in "Nume companie", with: @factura.nume_companie
    fill_in "Prenume", with: @factura.prenume
    fill_in "Pret unitar", with: @factura.pret_unitar
    fill_in "Produs", with: @factura.produs
    fill_in "Strada", with: @factura.strada
    fill_in "Tara", with: @factura.tara
    fill_in "User", with: @factura.user_id
    fill_in "Valoare totala", with: @factura.valoare_totala
    fill_in "Valoare tva", with: @factura.valoare_tva
    click_on "Create Factura"

    assert_text "Factura was successfully created"
    click_on "Back"
  end

  test "should update Factura" do
    visit factura_url(@factura)
    click_on "Edit this factura", match: :first

    fill_in "Cantitate", with: @factura.cantitate
    fill_in "Cod postal", with: @factura.cod_postal
    fill_in "Comanda", with: @factura.comanda_id
    fill_in "Cui", with: @factura.cui
    fill_in "Data emiterii", with: @factura.data_emiterii
    fill_in "Judet", with: @factura.judet
    fill_in "Localitate", with: @factura.localitate
    fill_in "Numar", with: @factura.numar
    fill_in "Numar adresa", with: @factura.numar_adresa
    fill_in "Numar comanda", with: @factura.numar_comanda
    fill_in "Nume", with: @factura.nume
    fill_in "Nume companie", with: @factura.nume_companie
    fill_in "Prenume", with: @factura.prenume
    fill_in "Pret unitar", with: @factura.pret_unitar
    fill_in "Produs", with: @factura.produs
    fill_in "Strada", with: @factura.strada
    fill_in "Tara", with: @factura.tara
    fill_in "User", with: @factura.user_id
    fill_in "Valoare totala", with: @factura.valoare_totala
    fill_in "Valoare tva", with: @factura.valoare_tva
    click_on "Update Factura"

    assert_text "Factura was successfully updated"
    click_on "Back"
  end

  test "should destroy Factura" do
    visit factura_url(@factura)
    click_on "Destroy this factura", match: :first

    assert_text "Factura was successfully destroyed"
  end
end
