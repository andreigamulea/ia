require "application_system_test_case"

class FirmeproformasTest < ApplicationSystemTestCase
  setup do
    @firmeproforma = firmeproformas(:one)
  end

  test "visiting the index" do
    visit firmeproformas_url
    assert_selector "h1", text: "Firmeproformas"
  end

  test "should create firmeproforma" do
    visit firmeproformas_url
    click_on "New firmeproforma"

    fill_in "Adresa", with: @firmeproforma.adresa
    fill_in "Banca", with: @firmeproforma.banca
    fill_in "Cod", with: @firmeproforma.cod
    fill_in "Cont", with: @firmeproforma.cont
    fill_in "Cui", with: @firmeproforma.cui
    fill_in "Nrinceput", with: @firmeproforma.nrinceput
    fill_in "Nume institutie", with: @firmeproforma.nume_institutie
    fill_in "Rc", with: @firmeproforma.rc
    fill_in "Serie", with: @firmeproforma.serie
    fill_in "Tva", with: @firmeproforma.tva
    click_on "Create Firmeproforma"

    assert_text "Firmeproforma was successfully created"
    click_on "Back"
  end

  test "should update Firmeproforma" do
    visit firmeproforma_url(@firmeproforma)
    click_on "Edit this firmeproforma", match: :first

    fill_in "Adresa", with: @firmeproforma.adresa
    fill_in "Banca", with: @firmeproforma.banca
    fill_in "Cod", with: @firmeproforma.cod
    fill_in "Cont", with: @firmeproforma.cont
    fill_in "Cui", with: @firmeproforma.cui
    fill_in "Nrinceput", with: @firmeproforma.nrinceput
    fill_in "Nume institutie", with: @firmeproforma.nume_institutie
    fill_in "Rc", with: @firmeproforma.rc
    fill_in "Serie", with: @firmeproforma.serie
    fill_in "Tva", with: @firmeproforma.tva
    click_on "Update Firmeproforma"

    assert_text "Firmeproforma was successfully updated"
    click_on "Back"
  end

  test "should destroy Firmeproforma" do
    visit firmeproforma_url(@firmeproforma)
    click_on "Destroy this firmeproforma", match: :first

    assert_text "Firmeproforma was successfully destroyed"
  end
end
