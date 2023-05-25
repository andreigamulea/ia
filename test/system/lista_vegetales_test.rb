require "application_system_test_case"

class ListaVegetalesTest < ApplicationSystemTestCase
  setup do
    @lista_vegetale = lista_vegetales(:one)
  end

  test "visiting the index" do
    visit lista_vegetales_url
    assert_selector "h1", text: "Lista vegetales"
  end

  test "should create lista vegetale" do
    visit lista_vegetales_url
    click_on "New lista vegetale"

    fill_in "Mentiunirestrictii", with: @lista_vegetale.mentiunirestrictii
    fill_in "Parteutilizata", with: @lista_vegetale.parteutilizata
    fill_in "Sinonime", with: @lista_vegetale.sinonime
    fill_in "Specie", with: @lista_vegetale.specie
    click_on "Create Lista vegetale"

    assert_text "Lista vegetale was successfully created"
    click_on "Back"
  end

  test "should update Lista vegetale" do
    visit lista_vegetale_url(@lista_vegetale)
    click_on "Edit this lista vegetale", match: :first

    fill_in "Mentiunirestrictii", with: @lista_vegetale.mentiunirestrictii
    fill_in "Parteutilizata", with: @lista_vegetale.parteutilizata
    fill_in "Sinonime", with: @lista_vegetale.sinonime
    fill_in "Specie", with: @lista_vegetale.specie
    click_on "Update Lista vegetale"

    assert_text "Lista vegetale was successfully updated"
    click_on "Back"
  end

  test "should destroy Lista vegetale" do
    visit lista_vegetale_url(@lista_vegetale)
    click_on "Destroy this lista vegetale", match: :first

    assert_text "Lista vegetale was successfully destroyed"
  end
end
