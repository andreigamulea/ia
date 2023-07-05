require "application_system_test_case"

class ProdsTest < ApplicationSystemTestCase
  setup do
    @prod = prods(:one)
  end

  test "visiting the index" do
    visit prods_url
    assert_selector "h1", text: "Prods"
  end

  test "should create prod" do
    visit prods_url
    click_on "New prod"

    fill_in "Curslegatura", with: @prod.curslegatura
    fill_in "Detalii", with: @prod.detalii
    fill_in "Info", with: @prod.info
    fill_in "Nume", with: @prod.nume
    fill_in "Pret", with: @prod.pret
    fill_in "Valabilitatezile", with: @prod.valabilitatezile
    click_on "Create Prod"

    assert_text "Prod was successfully created"
    click_on "Back"
  end

  test "should update Prod" do
    visit prod_url(@prod)
    click_on "Edit this prod", match: :first

    fill_in "Curslegatura", with: @prod.curslegatura
    fill_in "Detalii", with: @prod.detalii
    fill_in "Info", with: @prod.info
    fill_in "Nume", with: @prod.nume
    fill_in "Pret", with: @prod.pret
    fill_in "Valabilitatezile", with: @prod.valabilitatezile
    click_on "Update Prod"

    assert_text "Prod was successfully updated"
    click_on "Back"
  end

  test "should destroy Prod" do
    visit prod_url(@prod)
    click_on "Destroy this prod", match: :first

    assert_text "Prod was successfully destroyed"
  end
end
