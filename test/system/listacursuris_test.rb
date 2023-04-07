require "application_system_test_case"

class ListacursurisTest < ApplicationSystemTestCase
  setup do
    @listacursuri = listacursuris(:one)
  end

  test "visiting the index" do
    visit listacursuris_url
    assert_selector "h1", text: "Listacursuris"
  end

  test "should create listacursuri" do
    visit listacursuris_url
    click_on "New listacursuri"

    fill_in "Nume", with: @listacursuri.nume
    click_on "Create Listacursuri"

    assert_text "Listacursuri was successfully created"
    click_on "Back"
  end

  test "should update Listacursuri" do
    visit listacursuri_url(@listacursuri)
    click_on "Edit this listacursuri", match: :first

    fill_in "Nume", with: @listacursuri.nume
    click_on "Update Listacursuri"

    assert_text "Listacursuri was successfully updated"
    click_on "Back"
  end

  test "should destroy Listacursuri" do
    visit listacursuri_url(@listacursuri)
    click_on "Destroy this listacursuri", match: :first

    assert_text "Listacursuri was successfully destroyed"
  end
end
