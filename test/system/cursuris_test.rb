require "application_system_test_case"

class CursurisTest < ApplicationSystemTestCase
  setup do
    @cursuri = cursuris(:one)
  end

  test "visiting the index" do
    visit cursuris_url
    assert_selector "h1", text: "Cursuris"
  end

  test "should create cursuri" do
    visit cursuris_url
    click_on "New cursuri"

    fill_in "Datainceput", with: @cursuri.datainceput
    fill_in "Datasfarsit", with: @cursuri.datasfarsit
    fill_in "Numecurs", with: @cursuri.numecurs
    fill_in "User", with: @cursuri.user_id
    click_on "Create Cursuri"

    assert_text "Cursuri was successfully created"
    click_on "Back"
  end

  test "should update Cursuri" do
    visit cursuri_url(@cursuri)
    click_on "Edit this cursuri", match: :first

    fill_in "Datainceput", with: @cursuri.datainceput
    fill_in "Datasfarsit", with: @cursuri.datasfarsit
    fill_in "Numecurs", with: @cursuri.numecurs
    fill_in "User", with: @cursuri.user_id
    click_on "Update Cursuri"

    assert_text "Cursuri was successfully updated"
    click_on "Back"
  end

  test "should destroy Cursuri" do
    visit cursuri_url(@cursuri)
    click_on "Destroy this cursuri", match: :first

    assert_text "Cursuri was successfully destroyed"
  end
end
