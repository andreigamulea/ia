require "application_system_test_case"

class PaginisitesTest < ApplicationSystemTestCase
  setup do
    @paginisite = paginisites(:one)
  end

  test "visiting the index" do
    visit paginisites_url
    assert_selector "h1", text: "Paginisites"
  end

  test "should create paginisite" do
    visit paginisites_url
    click_on "New paginisite"

    fill_in "Nume", with: @paginisite.nume
    click_on "Create Paginisite"

    assert_text "Paginisite was successfully created"
    click_on "Back"
  end

  test "should update Paginisite" do
    visit paginisite_url(@paginisite)
    click_on "Edit this paginisite", match: :first

    fill_in "Nume", with: @paginisite.nume
    click_on "Update Paginisite"

    assert_text "Paginisite was successfully updated"
    click_on "Back"
  end

  test "should destroy Paginisite" do
    visit paginisite_url(@paginisite)
    click_on "Destroy this paginisite", match: :first

    assert_text "Paginisite was successfully destroyed"
  end
end
