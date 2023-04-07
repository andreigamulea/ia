require "application_system_test_case"

class RecomandarisTest < ApplicationSystemTestCase
  setup do
    @recomandari = recomandaris(:one)
  end

  test "visiting the index" do
    visit recomandaris_url
    assert_selector "h1", text: "Recomandaris"
  end

  test "should create recomandari" do
    visit recomandaris_url
    click_on "New recomandari"

    fill_in "Completari", with: @recomandari.completari
    fill_in "Idp", with: @recomandari.idp
    fill_in "Idpp", with: @recomandari.idpp
    fill_in "Idpr", with: @recomandari.idpr
    fill_in "Imp", with: @recomandari.imp
    fill_in "Listaproprietati", with: @recomandari.listaproprietati_id
    fill_in "Propayur", with: @recomandari.propayur
    fill_in "Propeng", with: @recomandari.propeng
    fill_in "Propgerm", with: @recomandari.propgerm
    fill_in "Proprietate", with: @recomandari.proprietate
    fill_in "Sel", with: @recomandari.sel
    fill_in "Srota", with: @recomandari.srota
    fill_in "Sursa", with: @recomandari.sursa
    fill_in "Tipp", with: @recomandari.tipp
    click_on "Create Recomandari"

    assert_text "Recomandari was successfully created"
    click_on "Back"
  end

  test "should update Recomandari" do
    visit recomandari_url(@recomandari)
    click_on "Edit this recomandari", match: :first

    fill_in "Completari", with: @recomandari.completari
    fill_in "Idp", with: @recomandari.idp
    fill_in "Idpp", with: @recomandari.idpp
    fill_in "Idpr", with: @recomandari.idpr
    fill_in "Imp", with: @recomandari.imp
    fill_in "Listaproprietati", with: @recomandari.listaproprietati_id
    fill_in "Propayur", with: @recomandari.propayur
    fill_in "Propeng", with: @recomandari.propeng
    fill_in "Propgerm", with: @recomandari.propgerm
    fill_in "Proprietate", with: @recomandari.proprietate
    fill_in "Sel", with: @recomandari.sel
    fill_in "Srota", with: @recomandari.srota
    fill_in "Sursa", with: @recomandari.sursa
    fill_in "Tipp", with: @recomandari.tipp
    click_on "Update Recomandari"

    assert_text "Recomandari was successfully updated"
    click_on "Back"
  end

  test "should destroy Recomandari" do
    visit recomandari_url(@recomandari)
    click_on "Destroy this recomandari", match: :first

    assert_text "Recomandari was successfully destroyed"
  end
end
