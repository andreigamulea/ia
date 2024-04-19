require "application_system_test_case"

class DateFacturaresTest < ApplicationSystemTestCase
  setup do
    @date_facturare = date_facturares(:one)
  end

  test "visiting the index" do
    visit date_facturares_url
    assert_selector "h1", text: "Date facturares"
  end

  test "should create date facturare" do
    visit date_facturares_url
    click_on "New date facturare"

    fill_in "Adresaemail", with: @date_facturare.adresaemail
    fill_in "Altedate", with: @date_facturare.altedate
    fill_in "Codpostal", with: @date_facturare.codpostal
    fill_in "Cpa", with: @date_facturare.cpa
    fill_in "Cui", with: @date_facturare.cui
    fill_in "Email", with: @date_facturare.email
    fill_in "Firma", with: @date_facturare.firma_id
    fill_in "Grupa2324", with: @date_facturare.grupa2324
    fill_in "Judet", with: @date_facturare.judet
    fill_in "Localitate", with: @date_facturare.localitate
    fill_in "Numar", with: @date_facturare.numar
    fill_in "Nume", with: @date_facturare.nume
    fill_in "Numecompanie", with: @date_facturare.numecompanie
    fill_in "Prenume", with: @date_facturare.prenume
    fill_in "Strada", with: @date_facturare.strada
    fill_in "Tara", with: @date_facturare.tara
    fill_in "Telefon", with: @date_facturare.telefon
    fill_in "User", with: @date_facturare.user_id
    click_on "Create Date facturare"

    assert_text "Date facturare was successfully created"
    click_on "Back"
  end

  test "should update Date facturare" do
    visit date_facturare_url(@date_facturare)
    click_on "Edit this date facturare", match: :first

    fill_in "Adresaemail", with: @date_facturare.adresaemail
    fill_in "Altedate", with: @date_facturare.altedate
    fill_in "Codpostal", with: @date_facturare.codpostal
    fill_in "Cpa", with: @date_facturare.cpa
    fill_in "Cui", with: @date_facturare.cui
    fill_in "Email", with: @date_facturare.email
    fill_in "Firma", with: @date_facturare.firma_id
    fill_in "Grupa2324", with: @date_facturare.grupa2324
    fill_in "Judet", with: @date_facturare.judet
    fill_in "Localitate", with: @date_facturare.localitate
    fill_in "Numar", with: @date_facturare.numar
    fill_in "Nume", with: @date_facturare.nume
    fill_in "Numecompanie", with: @date_facturare.numecompanie
    fill_in "Prenume", with: @date_facturare.prenume
    fill_in "Strada", with: @date_facturare.strada
    fill_in "Tara", with: @date_facturare.tara
    fill_in "Telefon", with: @date_facturare.telefon
    fill_in "User", with: @date_facturare.user_id
    click_on "Update Date facturare"

    assert_text "Date facturare was successfully updated"
    click_on "Back"
  end

  test "should destroy Date facturare" do
    visit date_facturare_url(@date_facturare)
    click_on "Destroy this date facturare", match: :first

    assert_text "Date facturare was successfully destroyed"
  end
end
