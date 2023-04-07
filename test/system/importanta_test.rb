require "application_system_test_case"

class ImportantaTest < ApplicationSystemTestCase
  setup do
    @importantum = importanta(:one)
  end

  test "visiting the index" do
    visit importanta_url
    assert_selector "h1", text: "Importanta"
  end

  test "should create importantum" do
    visit importanta_url
    click_on "New importantum"

    fill_in "Codimp", with: @importantum.codimp
    fill_in "Descgrad", with: @importantum.descgrad
    fill_in "Grad", with: @importantum.grad
    click_on "Create Importantum"

    assert_text "Importantum was successfully created"
    click_on "Back"
  end

  test "should update Importantum" do
    visit importantum_url(@importantum)
    click_on "Edit this importantum", match: :first

    fill_in "Codimp", with: @importantum.codimp
    fill_in "Descgrad", with: @importantum.descgrad
    fill_in "Grad", with: @importantum.grad
    click_on "Update Importantum"

    assert_text "Importantum was successfully updated"
    click_on "Back"
  end

  test "should destroy Importantum" do
    visit importantum_url(@importantum)
    click_on "Destroy this importantum", match: :first

    assert_text "Importantum was successfully destroyed"
  end
end
