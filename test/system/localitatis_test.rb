require "application_system_test_case"

class LocalitatisTest < ApplicationSystemTestCase
  setup do
    @localitati = localitatis(:one)
  end

  test "visiting the index" do
    visit localitatis_url
    assert_selector "h1", text: "Localitatis"
  end

  test "should create localitati" do
    visit localitatis_url
    click_on "New localitati"

    fill_in "Abr", with: @localitati.abr
    fill_in "Cod", with: @localitati.cod
    fill_in "Cod vechi", with: @localitati.cod_vechi
    fill_in "Denj", with: @localitati.denj
    fill_in "Denumire", with: @localitati.denumire
    fill_in "Judetid", with: @localitati.judetid
    click_on "Create Localitati"

    assert_text "Localitati was successfully created"
    click_on "Back"
  end

  test "should update Localitati" do
    visit localitati_url(@localitati)
    click_on "Edit this localitati", match: :first

    fill_in "Abr", with: @localitati.abr
    fill_in "Cod", with: @localitati.cod
    fill_in "Cod vechi", with: @localitati.cod_vechi
    fill_in "Denj", with: @localitati.denj
    fill_in "Denumire", with: @localitati.denumire
    fill_in "Judetid", with: @localitati.judetid
    click_on "Update Localitati"

    assert_text "Localitati was successfully updated"
    click_on "Back"
  end

  test "should destroy Localitati" do
    visit localitati_url(@localitati)
    click_on "Destroy this localitati", match: :first

    assert_text "Localitati was successfully destroyed"
  end
end
