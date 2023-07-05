require "application_system_test_case"

class ComandasTest < ApplicationSystemTestCase
  setup do
    @comanda = comandas(:one)
  end

  test "visiting the index" do
    visit comandas_url
    assert_selector "h1", text: "Comandas"
  end

  test "should create comanda" do
    visit comandas_url
    click_on "New comanda"

    fill_in "Datacomenzii", with: @comanda.datacomenzii
    fill_in "Emailcurrent", with: @comanda.emailcurrent
    fill_in "Emailplata", with: @comanda.emailplata
    fill_in "Numar", with: @comanda.numar
    fill_in "Plataprin", with: @comanda.plataprin
    fill_in "Statecomanda1", with: @comanda.statecomanda1
    fill_in "Statecomanda2", with: @comanda.statecomanda2
    fill_in "Stateplata1", with: @comanda.stateplata1
    fill_in "Stateplata2", with: @comanda.stateplata2
    fill_in "Stateplata3", with: @comanda.stateplata3
    fill_in "Total", with: @comanda.total
    fill_in "User", with: @comanda.user_id
    click_on "Create Comanda"

    assert_text "Comanda was successfully created"
    click_on "Back"
  end

  test "should update Comanda" do
    visit comanda_url(@comanda)
    click_on "Edit this comanda", match: :first

    fill_in "Datacomenzii", with: @comanda.datacomenzii
    fill_in "Emailcurrent", with: @comanda.emailcurrent
    fill_in "Emailplata", with: @comanda.emailplata
    fill_in "Numar", with: @comanda.numar
    fill_in "Plataprin", with: @comanda.plataprin
    fill_in "Statecomanda1", with: @comanda.statecomanda1
    fill_in "Statecomanda2", with: @comanda.statecomanda2
    fill_in "Stateplata1", with: @comanda.stateplata1
    fill_in "Stateplata2", with: @comanda.stateplata2
    fill_in "Stateplata3", with: @comanda.stateplata3
    fill_in "Total", with: @comanda.total
    fill_in "User", with: @comanda.user_id
    click_on "Update Comanda"

    assert_text "Comanda was successfully updated"
    click_on "Back"
  end

  test "should destroy Comanda" do
    visit comanda_url(@comanda)
    click_on "Destroy this comanda", match: :first

    assert_text "Comanda was successfully destroyed"
  end
end
