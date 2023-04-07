require "application_system_test_case"

class ValorinutritionalesTest < ApplicationSystemTestCase
  setup do
    @valorinutritionale = valorinutritionales(:one)
  end

  test "visiting the index" do
    visit valorinutritionales_url
    assert_selector "h1", text: "Valorinutritionales"
  end

  test "should create valorinutritionale" do
    visit valorinutritionales_url
    click_on "New valorinutritionale"

    fill_in "Aliment", with: @valorinutritionale.aliment
    fill_in "Calorii", with: @valorinutritionale.calorii
    fill_in "Carbohidrati", with: @valorinutritionale.carbohidrati
    fill_in "Cod", with: @valorinutritionale.cod
    fill_in "Fibre", with: @valorinutritionale.fibre
    fill_in "Lipide", with: @valorinutritionale.lipide
    fill_in "Proteine", with: @valorinutritionale.proteine
    click_on "Create Valorinutritionale"

    assert_text "Valorinutritionale was successfully created"
    click_on "Back"
  end

  test "should update Valorinutritionale" do
    visit valorinutritionale_url(@valorinutritionale)
    click_on "Edit this valorinutritionale", match: :first

    fill_in "Aliment", with: @valorinutritionale.aliment
    fill_in "Calorii", with: @valorinutritionale.calorii
    fill_in "Carbohidrati", with: @valorinutritionale.carbohidrati
    fill_in "Cod", with: @valorinutritionale.cod
    fill_in "Fibre", with: @valorinutritionale.fibre
    fill_in "Lipide", with: @valorinutritionale.lipide
    fill_in "Proteine", with: @valorinutritionale.proteine
    click_on "Update Valorinutritionale"

    assert_text "Valorinutritionale was successfully updated"
    click_on "Back"
  end

  test "should destroy Valorinutritionale" do
    visit valorinutritionale_url(@valorinutritionale)
    click_on "Destroy this valorinutritionale", match: :first

    assert_text "Valorinutritionale was successfully destroyed"
  end
end
