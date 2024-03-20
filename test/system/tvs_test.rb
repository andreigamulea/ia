require "application_system_test_case"

class TvsTest < ApplicationSystemTestCase
  setup do
    @tv = tvs(:one)
  end

  test "visiting the index" do
    visit tvs_url
    assert_selector "h1", text: "Tvs"
  end

  test "should create tv" do
    visit tvs_url
    click_on "New tv"

    fill_in "Canal", with: @tv.canal
    fill_in "Cine", with: @tv.cine
    fill_in "Datainceput", with: @tv.datainceput
    fill_in "Datasfarsit", with: @tv.datasfarsit
    fill_in "Denumire", with: @tv.denumire
    fill_in "Link", with: @tv.link
    fill_in "Mininceput", with: @tv.mininceput
    fill_in "Minsfarsit", with: @tv.minsfarsit
    fill_in "Orainceput", with: @tv.orainceput
    fill_in "Orasfarsit", with: @tv.orasfarsit
    fill_in "Referinta", with: @tv.referinta
    fill_in "User", with: @tv.user_id
    click_on "Create Tv"

    assert_text "Tv was successfully created"
    click_on "Back"
  end

  test "should update Tv" do
    visit tv_url(@tv)
    click_on "Edit this tv", match: :first

    fill_in "Canal", with: @tv.canal
    fill_in "Cine", with: @tv.cine
    fill_in "Datainceput", with: @tv.datainceput
    fill_in "Datasfarsit", with: @tv.datasfarsit
    fill_in "Denumire", with: @tv.denumire
    fill_in "Link", with: @tv.link
    fill_in "Mininceput", with: @tv.mininceput
    fill_in "Minsfarsit", with: @tv.minsfarsit
    fill_in "Orainceput", with: @tv.orainceput
    fill_in "Orasfarsit", with: @tv.orasfarsit
    fill_in "Referinta", with: @tv.referinta
    fill_in "User", with: @tv.user_id
    click_on "Update Tv"

    assert_text "Tv was successfully updated"
    click_on "Back"
  end

  test "should destroy Tv" do
    visit tv_url(@tv)
    click_on "Destroy this tv", match: :first

    assert_text "Tv was successfully destroyed"
  end
end
