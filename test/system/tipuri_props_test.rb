require "application_system_test_case"

class TipuriPropsTest < ApplicationSystemTestCase
  setup do
    @tipuri_prop = tipuri_props(:one)
  end

  test "visiting the index" do
    visit tipuri_props_url
    assert_selector "h1", text: "Tipuri props"
  end

  test "should create tipuri prop" do
    visit tipuri_props_url
    click_on "New tipuri prop"

    fill_in "Cp", with: @tipuri_prop.cp
    fill_in "Explicatie", with: @tipuri_prop.explicatie
    fill_in "Idxcp", with: @tipuri_prop.idxcp
    click_on "Create Tipuri prop"

    assert_text "Tipuri prop was successfully created"
    click_on "Back"
  end

  test "should update Tipuri prop" do
    visit tipuri_prop_url(@tipuri_prop)
    click_on "Edit this tipuri prop", match: :first

    fill_in "Cp", with: @tipuri_prop.cp
    fill_in "Explicatie", with: @tipuri_prop.explicatie
    fill_in "Idxcp", with: @tipuri_prop.idxcp
    click_on "Update Tipuri prop"

    assert_text "Tipuri prop was successfully updated"
    click_on "Back"
  end

  test "should destroy Tipuri prop" do
    visit tipuri_prop_url(@tipuri_prop)
    click_on "Destroy this tipuri prop", match: :first

    assert_text "Tipuri prop was successfully destroyed"
  end
end
