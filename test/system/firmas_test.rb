require "application_system_test_case"

class FirmasTest < ApplicationSystemTestCase
  setup do
    @firma = firmas(:one)
  end

  test "visiting the index" do
    visit firmas_url
    assert_selector "h1", text: "Firmas"
  end

  test "should create firma" do
    visit firmas_url
    click_on "New firma"

    fill_in "Adresa", with: @firma.adresa
    fill_in "Banca", with: @firma.banca
    fill_in "Cont", with: @firma.cont
    fill_in "Cui", with: @firma.cui
    fill_in "Nrinceput", with: @firma.nrinceput
    fill_in "Nume institutie", with: @firma.nume_institutie
    fill_in "Rc", with: @firma.rc
    fill_in "Serie", with: @firma.serie
    click_on "Create Firma"

    assert_text "Firma was successfully created"
    click_on "Back"
  end

  test "should update Firma" do
    visit firma_url(@firma)
    click_on "Edit this firma", match: :first

    fill_in "Adresa", with: @firma.adresa
    fill_in "Banca", with: @firma.banca
    fill_in "Cont", with: @firma.cont
    fill_in "Cui", with: @firma.cui
    fill_in "Nrinceput", with: @firma.nrinceput
    fill_in "Nume institutie", with: @firma.nume_institutie
    fill_in "Rc", with: @firma.rc
    fill_in "Serie", with: @firma.serie
    click_on "Update Firma"

    assert_text "Firma was successfully updated"
    click_on "Back"
  end

  test "should destroy Firma" do
    visit firma_url(@firma)
    click_on "Destroy this firma", match: :first

    assert_text "Firma was successfully destroyed"
  end
end
