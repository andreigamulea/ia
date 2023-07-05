require "application_system_test_case"

class ProdusTest < ApplicationSystemTestCase
  setup do
    @produ = produs(:one)
  end

  test "visiting the index" do
    visit produs_url
    assert_selector "h1", text: "Produs"
  end

  test "should create produ" do
    visit produs_url
    click_on "New produ"

    fill_in "Curslegatura", with: @produ.curslegatura
    fill_in "Detalii", with: @produ.detalii
    fill_in "Info", with: @produ.info
    fill_in "Nume", with: @produ.nume
    fill_in "Pret", with: @produ.pret
    fill_in "Valabilitatezile", with: @produ.valabilitatezile
    click_on "Create Produ"

    assert_text "Produ was successfully created"
    click_on "Back"
  end

  test "should update Produ" do
    visit produ_url(@produ)
    click_on "Edit this produ", match: :first

    fill_in "Curslegatura", with: @produ.curslegatura
    fill_in "Detalii", with: @produ.detalii
    fill_in "Info", with: @produ.info
    fill_in "Nume", with: @produ.nume
    fill_in "Pret", with: @produ.pret
    fill_in "Valabilitatezile", with: @produ.valabilitatezile
    click_on "Update Produ"

    assert_text "Produ was successfully updated"
    click_on "Back"
  end

  test "should destroy Produ" do
    visit produ_url(@produ)
    click_on "Destroy this produ", match: :first

    assert_text "Produ was successfully destroyed"
  end
end
