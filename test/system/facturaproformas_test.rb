require "application_system_test_case"

class FacturaproformasTest < ApplicationSystemTestCase
  setup do
    @facturaproforma = facturaproformas(:one)
  end

  test "visiting the index" do
    visit facturaproformas_url
    assert_selector "h1", text: "Facturaproformas"
  end

  test "should create facturaproforma" do
    visit facturaproformas_url
    click_on "New facturaproforma"

    fill_in "Altedate", with: @facturaproforma.altedate
    fill_in "Cantitate", with: @facturaproforma.cantitate
    fill_in "Cod firma", with: @facturaproforma.cod_firma
    fill_in "Cod postal", with: @facturaproforma.cod_postal
    fill_in "Comanda", with: @facturaproforma.comanda_id
    fill_in "Cui", with: @facturaproforma.cui
    fill_in "Data emiterii", with: @facturaproforma.data_emiterii
    fill_in "Judet", with: @facturaproforma.judet
    fill_in "Localitate", with: @facturaproforma.localitate
    fill_in "Numar adresa", with: @facturaproforma.numar_adresa
    fill_in "Numar comanda", with: @facturaproforma.numar_comanda
    fill_in "Numar factura", with: @facturaproforma.numar_factura
    fill_in "Nume", with: @facturaproforma.nume
    fill_in "Nume companie", with: @facturaproforma.nume_companie
    fill_in "Prenume", with: @facturaproforma.prenume
    fill_in "Pret unitar", with: @facturaproforma.pret_unitar
    fill_in "Prod", with: @facturaproforma.prod_id
    fill_in "Produs", with: @facturaproforma.produs
    fill_in "Status", with: @facturaproforma.status
    fill_in "Strada", with: @facturaproforma.strada
    fill_in "Tara", with: @facturaproforma.tara
    fill_in "Telefon", with: @facturaproforma.telefon
    fill_in "User", with: @facturaproforma.user_id
    fill_in "Valoare totala", with: @facturaproforma.valoare_totala
    fill_in "Valoare tva", with: @facturaproforma.valoare_tva
    click_on "Create Facturaproforma"

    assert_text "Facturaproforma was successfully created"
    click_on "Back"
  end

  test "should update Facturaproforma" do
    visit facturaproforma_url(@facturaproforma)
    click_on "Edit this facturaproforma", match: :first

    fill_in "Altedate", with: @facturaproforma.altedate
    fill_in "Cantitate", with: @facturaproforma.cantitate
    fill_in "Cod firma", with: @facturaproforma.cod_firma
    fill_in "Cod postal", with: @facturaproforma.cod_postal
    fill_in "Comanda", with: @facturaproforma.comanda_id
    fill_in "Cui", with: @facturaproforma.cui
    fill_in "Data emiterii", with: @facturaproforma.data_emiterii
    fill_in "Judet", with: @facturaproforma.judet
    fill_in "Localitate", with: @facturaproforma.localitate
    fill_in "Numar adresa", with: @facturaproforma.numar_adresa
    fill_in "Numar comanda", with: @facturaproforma.numar_comanda
    fill_in "Numar factura", with: @facturaproforma.numar_factura
    fill_in "Nume", with: @facturaproforma.nume
    fill_in "Nume companie", with: @facturaproforma.nume_companie
    fill_in "Prenume", with: @facturaproforma.prenume
    fill_in "Pret unitar", with: @facturaproforma.pret_unitar
    fill_in "Prod", with: @facturaproforma.prod_id
    fill_in "Produs", with: @facturaproforma.produs
    fill_in "Status", with: @facturaproforma.status
    fill_in "Strada", with: @facturaproforma.strada
    fill_in "Tara", with: @facturaproforma.tara
    fill_in "Telefon", with: @facturaproforma.telefon
    fill_in "User", with: @facturaproforma.user_id
    fill_in "Valoare totala", with: @facturaproforma.valoare_totala
    fill_in "Valoare tva", with: @facturaproforma.valoare_tva
    click_on "Update Facturaproforma"

    assert_text "Facturaproforma was successfully updated"
    click_on "Back"
  end

  test "should destroy Facturaproforma" do
    visit facturaproforma_url(@facturaproforma)
    click_on "Destroy this facturaproforma", match: :first

    assert_text "Facturaproforma was successfully destroyed"
  end
end
