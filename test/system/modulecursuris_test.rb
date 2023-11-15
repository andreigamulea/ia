require "application_system_test_case"

class ModulecursurisTest < ApplicationSystemTestCase
  setup do
    @modulecursuri = modulecursuris(:one)
  end

  test "visiting the index" do
    visit modulecursuris_url
    assert_selector "h1", text: "Modulecursuris"
  end

  test "should create modulecursuri" do
    visit modulecursuris_url
    click_on "New modulecursuri"

    fill_in "Nume", with: @modulecursuri.nume
    click_on "Create Modulecursuri"

    assert_text "Modulecursuri was successfully created"
    click_on "Back"
  end

  test "should update Modulecursuri" do
    visit modulecursuri_url(@modulecursuri)
    click_on "Edit this modulecursuri", match: :first

    fill_in "Nume", with: @modulecursuri.nume
    click_on "Update Modulecursuri"

    assert_text "Modulecursuri was successfully updated"
    click_on "Back"
  end

  test "should destroy Modulecursuri" do
    visit modulecursuri_url(@modulecursuri)
    click_on "Destroy this modulecursuri", match: :first

    assert_text "Modulecursuri was successfully destroyed"
  end
end
