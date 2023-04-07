require "application_system_test_case"

class PlantesTest < ApplicationSystemTestCase
  setup do
    @plante = plantes(:one)
  end

  test "visiting the index" do
    visit plantes_url
    assert_selector "h1", text: "Plantes"
  end

  test "should create plante" do
    visit plantes_url
    click_on "New plante"

    fill_in "Denbot", with: @plante.denbot
    fill_in "Fam", with: @plante.fam
    fill_in "Idp", with: @plante.idp
    fill_in "Nume", with: @plante.nume
    fill_in "Numeayu", with: @plante.numeayu
    fill_in "Numesec", with: @plante.numesec
    fill_in "Numesec2", with: @plante.numesec2
    fill_in "Subt", with: @plante.subt
    fill_in "Tip", with: @plante.tip
    click_on "Create Plante"

    assert_text "Plante was successfully created"
    click_on "Back"
  end

  test "should update Plante" do
    visit plante_url(@plante)
    click_on "Edit this plante", match: :first

    fill_in "Denbot", with: @plante.denbot
    fill_in "Fam", with: @plante.fam
    fill_in "Idp", with: @plante.idp
    fill_in "Nume", with: @plante.nume
    fill_in "Numeayu", with: @plante.numeayu
    fill_in "Numesec", with: @plante.numesec
    fill_in "Numesec2", with: @plante.numesec2
    fill_in "Subt", with: @plante.subt
    fill_in "Tip", with: @plante.tip
    click_on "Update Plante"

    assert_text "Plante was successfully updated"
    click_on "Back"
  end

  test "should destroy Plante" do
    visit plante_url(@plante)
    click_on "Destroy this plante", match: :first

    assert_text "Plante was successfully destroyed"
  end
end
