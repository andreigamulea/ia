require "application_system_test_case"

class CursuriayurvedasTest < ApplicationSystemTestCase
  setup do
    @cursuriayurveda = cursuriayurvedas(:one)
  end

  test "visiting the index" do
    visit cursuriayurvedas_url
    assert_selector "h1", text: "Cursuriayurvedas"
  end

  test "should create cursuriayurveda" do
    visit cursuriayurvedas_url
    click_on "New cursuriayurveda"

    fill_in "Grupa", with: @cursuriayurveda.grupa
    click_on "Create Cursuriayurveda"

    assert_text "Cursuriayurveda was successfully created"
    click_on "Back"
  end

  test "should update Cursuriayurveda" do
    visit cursuriayurveda_url(@cursuriayurveda)
    click_on "Edit this cursuriayurveda", match: :first

    fill_in "Grupa", with: @cursuriayurveda.grupa
    click_on "Update Cursuriayurveda"

    assert_text "Cursuriayurveda was successfully updated"
    click_on "Back"
  end

  test "should destroy Cursuriayurveda" do
    visit cursuriayurveda_url(@cursuriayurveda)
    click_on "Destroy this cursuriayurveda", match: :first

    assert_text "Cursuriayurveda was successfully destroyed"
  end
end
