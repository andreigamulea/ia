require "application_system_test_case"

class SrotaTest < ApplicationSystemTestCase
  setup do
    @srotum = srota(:one)
  end

  test "visiting the index" do
    visit srota_url
    assert_selector "h1", text: "Srota"
  end

  test "should create srotum" do
    visit srota_url
    click_on "New srotum"

    fill_in "Codsr", with: @srotum.codsr
    fill_in "Codsrota", with: @srotum.codsrota
    fill_in "Explicatie", with: @srotum.explicatie
    fill_in "Functii", with: @srotum.functii
    fill_in "Numescurt", with: @srotum.numescurt
    fill_in "Numesrota", with: @srotum.numesrota
    fill_in "Observatie", with: @srotum.observatie
    fill_in "Origine", with: @srotum.origine
    fill_in "Parti", with: @srotum.parti
    click_on "Create Srotum"

    assert_text "Srotum was successfully created"
    click_on "Back"
  end

  test "should update Srotum" do
    visit srotum_url(@srotum)
    click_on "Edit this srotum", match: :first

    fill_in "Codsr", with: @srotum.codsr
    fill_in "Codsrota", with: @srotum.codsrota
    fill_in "Explicatie", with: @srotum.explicatie
    fill_in "Functii", with: @srotum.functii
    fill_in "Numescurt", with: @srotum.numescurt
    fill_in "Numesrota", with: @srotum.numesrota
    fill_in "Observatie", with: @srotum.observatie
    fill_in "Origine", with: @srotum.origine
    fill_in "Parti", with: @srotum.parti
    click_on "Update Srotum"

    assert_text "Srotum was successfully updated"
    click_on "Back"
  end

  test "should destroy Srotum" do
    visit srotum_url(@srotum)
    click_on "Destroy this srotum", match: :first

    assert_text "Srotum was successfully destroyed"
  end
end
