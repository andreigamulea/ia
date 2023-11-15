require "application_system_test_case"

class TipconstitutionalsTest < ApplicationSystemTestCase
  setup do
    @tipconstitutional = tipconstitutionals(:one)
  end

  test "visiting the index" do
    visit tipconstitutionals_url
    assert_selector "h1", text: "Tipconstitutionals"
  end

  test "should create tipconstitutional" do
    visit tipconstitutionals_url
    click_on "New tipconstitutional"

    fill_in "Caracteristica", with: @tipconstitutional.caracteristica
    fill_in "Nr", with: @tipconstitutional.nr
    fill_in "Nrtip", with: @tipconstitutional.nrtip
    fill_in "Tip", with: @tipconstitutional.tip
    click_on "Create Tipconstitutional"

    assert_text "Tipconstitutional was successfully created"
    click_on "Back"
  end

  test "should update Tipconstitutional" do
    visit tipconstitutional_url(@tipconstitutional)
    click_on "Edit this tipconstitutional", match: :first

    fill_in "Caracteristica", with: @tipconstitutional.caracteristica
    fill_in "Nr", with: @tipconstitutional.nr
    fill_in "Nrtip", with: @tipconstitutional.nrtip
    fill_in "Tip", with: @tipconstitutional.tip
    click_on "Update Tipconstitutional"

    assert_text "Tipconstitutional was successfully updated"
    click_on "Back"
  end

  test "should destroy Tipconstitutional" do
    visit tipconstitutional_url(@tipconstitutional)
    click_on "Destroy this tipconstitutional", match: :first

    assert_text "Tipconstitutional was successfully destroyed"
  end
end
